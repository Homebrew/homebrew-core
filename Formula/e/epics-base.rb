class EpicsBase < Formula
  desc "Experimental Physics and Industrial Control System"
  homepage "https://epics-controls.org/"
  url "https://github.com/epics-base/epics-base.git",
     tag:      "R7.0.10",
     revision: "bf11a0c31c919ba85ba2e23b72bcf0b5f9f62e77"
  license "EPICS"

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "b20b14d64026eabd3e617aec7dce5fb7724b83bff4de941802f9c27b4cf64055"
    sha256 arm64_sequoia: "175210994ae785846d9d0659b91ec166ea26eecfa8347fa0a2209c189294adf4"
    sha256 arm64_sonoma:  "c4039118d444500c3cccb0efb38a39b0ecee7da21ac1aeb2af2ee784ef5dcae1"
    sha256 sonoma:        "e47190cedf616e26da12813b64d50ed53fe667c9585a32e70d4a86766a4a833c"
    sha256 arm64_linux:   "e3339438b5410ad2d7e37c8c03670f770f41af5f6623ee70e417e9ae21b38c5c"
    sha256 x86_64_linux:  "96ff661a4f2c20e926d3561608358e9854b26dce71c80be58f9b407a63200e72"
  end

  depends_on "pkgconf" => :build
  depends_on "perl"
  depends_on "readline"

  conflicts_with "libffcall", because: "both install `callback.h` header"

  patch do
    url "https://github.com/epics-base/epics-base/commit/2c4d4714acbfd4ec6a26dcf0d7b9823475251d16.patch?full_index=1"
    sha256 "d71ff147064b3d305365b2e05a7810d3d4beed10692a343b955a76ba13d440eb"
    type :backport
    resolves "https://github.com/epics-base/epics-base/issues/895"
  end

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
