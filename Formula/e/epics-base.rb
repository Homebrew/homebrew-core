class EpicsBase < Formula
  desc "Experimental Physics and Industrial Control System"
  homepage "https://epics-controls.org/"
  url "https://github.com/epics-base/epics-base.git",
     tag:      "R7.0.10",
     revision: "bf11a0c31c919ba85ba2e23b72bcf0b5f9f62e77"
  license "EPICS"

  bottle do
    sha256 arm64_tahoe:   "1d968b86ccf1e6f0ac9719f1c9d1d0d655640c291e46fd770c486f3426494a0c"
    sha256 arm64_sequoia: "93575bed27b485d2d5b79091a0ce7cf7ef6093017d8c8aa73ab8f5c80deb48e2"
    sha256 arm64_sonoma:  "140d4597e79db78ecc9153713d4eef31f3373db673c0db7c45b0ce3d8f0a83fa"
    sha256 sonoma:        "1ed2e59b9059ca2fe5ff9fc4d8eced70a98f6e4b9d8af978e6f81ca179dd3aad"
    sha256 arm64_linux:   "8927a347d1a0d42ac3ee19e805ae9909928f066323049ac255e2b296b1b3d360"
    sha256 x86_64_linux:  "b4e7ccfa3d3540c0d181724d4f0068d3735be05eee93b94a0ff52784161e01ff"
  end

  depends_on "pkgconf" => :build
  depends_on "perl"
  depends_on "readline"

  def install
    hostarch = Utils.safe_popen_read("./startup/EpicsHostArch").strip
    ENV["EPICS_HOST_ARCH"] = hostarch
    ENV["EPICS_BASE"] = buildpath
    # Override base configuration with CONFIG_SITE.local to force Filesystem Hierarchy Standard usage
    (buildpath/"configure/CONFIG_SITE.local").write <<~EOS
      INSTALL_LOCATION = #{libexec}
      SHRLIB_LDFLAGS = -dynamiclib
    EOS

    # avoid errors from linker, see: https://github.com/epics-base/epics-base/issues/895
    inreplace "configure/os/CONFIG.darwinCommon.darwinCommon", /-flat_namespace/, ""

    system "make"
    # only these files are copied over to bin
    user_tools = %w[
      caget caput camonitor cainfo cawait casw caRepeater
      pvget pvput pvinfo pvlist pvcall pvmonitor EpicsHostArch.pl
    ]
    user_tools.each do |t|
      src = prefix/"libexec/bin"/hostarch/t
      bin.install_symlink src => t
    end
    user_libs = Dir["#{libexec}/lib/#{hostarch}/*.{dylib,so}*"]
    user_libs.each do |t|
      lib.install_symlink t
    end
    bin.install_symlink "#{libexec}/bin/#{hostarch}/EpicsHostArch.pl" => "EpicsHostArch.pl"
    bin.install_symlink "#{libexec}/bin/#{hostarch}/softIoc" => "softioc"
    bin.install_symlink "#{libexec}/bin/#{hostarch}/softIocPVA" => "softiocpva"
    include.install_symlink Dir[libexec/"include/*"]
  end

  def caveats
    <<~EOS
      To use EPICS in the shell you have to put this here into shell configuration:
        export EPICS_BASE=#{opt_prefix}/libexec
        export EPICS_HOST_ARCH=$(#{opt_prefix}/bin/EpicsHostArch.pl)

    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/caput -V")

    assert_match "Channel connect timed out", shell_output("#{bin}/caput HOMEBREW:TEST 1 2>&1", 1)

    assert_match "Channel connect timed out", shell_output("#{bin}/caget HOMEBREW:TEST 2>&1", 1)

    ca_port      = free_port
    ca_repeater  = free_port
    pva_port     = free_port

    ENV["EPICS_CA_ADDR_LIST"]         = "127.0.0.1"
    ENV["EPICS_CA_AUTO_ADDR_LIST"]    = "NO"
    ENV["EPICS_CAS_INTF_ADDR_LIST"]   = "127.0.0.1"
    ENV["EPICS_CAS_BEACON_ADDR_LIST"] = "127.0.0.1"
    # Channel Access (CA)
    ENV["EPICS_CA_SERVER_PORT"]   = ca_port.to_s
    ENV["EPICS_CA_REPEATER_PORT"] = ca_repeater.to_s

    # PV Access (PVA)
    ENV["EPICS_PVA_SERVER_PORT"]  = pva_port.to_s
    ENV["EPICS_PVA_BROADCAST_PORT"] = free_port.to_s

    (testpath/"test.db").write <<~EOS
      record(ao,"HOMEBREW:TEST") {
      field(DTYP,"Soft Channel")
      field(VAL,"5.0")
      }
    EOS

    (testpath/"st.cmd").write <<~EOS
      dbLoadDatabase("#{testpath}/test.db")
      dbLoadRecords("#{libexec}/db/softIocExit.db","IOC=HOMEBREW")
      iocInit()
      dbgf("HOMEBREW:TEST")
      dbpf("HOMEBREW:exit",0)

    EOS

    output = shell_output("#{bin}/softiocpva -D #{libexec}/dbd/softIocPVA.dbd st.cmd 2>&1")
    assert_match "HOMEBREW:TEST", output
    assert_match "5", output
  end
end
