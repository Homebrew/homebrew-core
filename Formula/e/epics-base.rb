class EpicsBase < Formula
  desc "Experimental Physics and Industrial Control System"
  homepage "https://epics-controls.org/"
  url "https://github.com/epics-base/epics-base.git",
     tag:      "R7.0.11",
     revision: "9d60f8d0d383dd54a3f02695bfdfcb4fad29586d"
  license "EPICS"

  bottle do
    sha256 arm64_golden_gate: "ed77fd6ad61f706d1e35fcda9f0600b6d8877a6cee59722dac39cefba59bd165"
    sha256 arm64_tahoe:       "fae2436bdcc40f6c1c563997827270e24ef61a96e7a7cbfeccb384c7f2c2c3e3"
    sha256 arm64_sequoia:     "778f9ff0bd8eecefffebe17c556adb40b5aa5fbf3068f80904074a2d1c1c78af"
    sha256 arm64_linux:       "a9569da7e1f7e5f34bef7b13edb573dc4a78cbf3c2afd924b70dbbb886cce94d"
    sha256 x86_64_linux:      "8aa6aa76b66159dbcd5920fbc4441ce956af9e3e006363bf5ba0a701d53553b1"
  end

  depends_on "pkgconf" => :build
  depends_on "perl"
  depends_on "readline"

  conflicts_with "libffcall", because: "both install `callback.h` header"

  def install
    hostarch = Utils.safe_popen_read("./startup/EpicsHostArch").strip
    ENV["EPICS_HOST_ARCH"] = hostarch
    ENV["EPICS_BASE"] = buildpath
    # Override base configuration with CONFIG_SITE.local to force Filesystem Hierarchy Standard usage
    (buildpath/"configure/CONFIG_SITE.local").write <<~EOS
      INSTALL_LOCATION = #{libexec}
      SHRLIB_LDFLAGS = -dynamiclib
    EOS

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
