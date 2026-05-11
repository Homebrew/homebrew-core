class Epicsbase < Formula
  desc "Experimental Physics and Industrial Control System"
  homepage "https://epics-controls.org/"
  url "https://github.com/epics-base/epics-base.git",
     tag:      "R7.0.10",
     revision: "bf11a0c31c919ba85ba2e23b72bcf0b5f9f62e77"
  license "EPICS"
  depends_on "pkg-config" => :build
  depends_on "perl"
  depends_on "readline"
  patch do
    url "https://github.com/HelgeBrands/homebrew-core/raw/refs/heads/main/Patches/epicsbase/fix-build.diff"
    sha256 "b988e750302893a206ed01e854dec0df04b4a23707a92bdc9f4096e0936c9b2d"
  end
  def install
    # EPICS needed this environment variables
    ENV["EPICS_HOST_ARCH"] = Utils.safe_popen_read("./startup/EpicsHostArch").strip
    hostarch = Utils.safe_popen_read("./startup/EpicsHostArch").strip
    puts "EPICS_HOST_ARCH = #{hostarch}"
    ENV["EPICS_BASE"] = buildpath
    # Optional: optinal config files
    inreplace "configure/CONFIG_SITE", /#?INSTALL_LOCATION=.*/, "INSTALL_LOCATION=#{prefix}"
    system "make"
    # installation: simply copy over this stuff
    prefix.install Dir["*"]

    bin.install_symlink "#{prefix}/bin/#{hostarch}/caget" => "caget"
    bin.install_symlink "#{prefix}/bin/#{hostarch}/caput" => "caput"
    bin.install_symlink "#{prefix}/bin/#{hostarch}/catime" => "catime"
    bin.install_symlink "#{prefix}/bin/#{hostarch}/cainfo" => "cainfo"
    bin.install_symlink "#{prefix}/bin/#{hostarch}/caEventRate" => "caEventRate"
    bin.install_symlink "#{prefix}/bin/#{hostarch}/camonitor" => "camonitor"

    bin.install_symlink "#{prefix}/bin/#{hostarch}/pvget" => "pvget"
    bin.install_symlink "#{prefix}/bin/#{hostarch}/pvput" => "pvput"
    bin.install_symlink "#{prefix}/bin/#{hostarch}/pvinfo" => "pvinfo"
    bin.install_symlink "#{prefix}/bin/#{hostarch}/pvlist" => "pvlist"
    bin.install_symlink "#{prefix}/bin/#{hostarch}/pvmonitor" => "pvmonitor"

    bin.install_symlink "#{prefix}/bin/#{hostarch}/softIoc" => "softIoc"
    bin.install_symlink "#{prefix}/bin/#{hostarch}/softIoc" => "softioc"
    bin.install_symlink "#{prefix}/bin/#{hostarch}/softIocPVA" => "softIocPVA"
    bin.install_symlink "#{prefix}/bin/#{hostarch}/softIocPVA" => "softiocpva"
  end

  def caveats
    <<~EOS
      EPICS Base is installed

      To use EPICS in the shell you have to put this here into shell configuration:
        export EPICS_BASE=#{opt_prefix}
        export EPICS_HOST_ARCH=$(#{opt_prefix}/startup/EpicsHostArch)

    EOS
  end

  test do
    hostarch = Utils.safe_popen_read("#{prefix}/startup/EpicsHostArch").strip
    puts "EPICS_HOST_ARCH = #{hostarch}"
    # simple test if these files exists
    assert_path_exists "#{prefix}/bin/#{hostarch}/caput", :exist?
    assert_match "EPICS Version", shell_output("#{bin}/caput -V")
    assert_path_exists "#{prefix}/bin/#{hostarch}/caget", :exist?
    assert_match "EPICS Version", shell_output("#{bin}/caget -V")

    assert_path_exists "#{prefix}/bin/#{hostarch}/pvget", :exist?
    output = Utils.safe_popen_read("#{bin}/pvget", "-h", err: :out)
    assert_match "Usage: pvget", output

    assert_path_exists "#{prefix}/bin/#{hostarch}/pvput", :exist?
    output = Utils.safe_popen_read("#{bin}/pvput", "-h", err: :out)  rescue ""
    assert_match "Usage: pvput", output

    assert_path_exists "#{prefix}/bin/#{hostarch}/softIoc", :exist?
    assert_match "Usage: softioc", shell_output("softioc -h")
    assert_path_exists "#{prefix}/bin/#{hostarch}/softIocPVA", :exist?
    assert_match "Usage: softiocpva", shell_output("softiocpva -h")
  end
end
