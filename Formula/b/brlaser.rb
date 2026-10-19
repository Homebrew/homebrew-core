class Brlaser < Formula
  desc "CUPS driver for monochrome Brother laser printers"
  homepage "https://github.com/Owl-Maintain/brlaser"
  url "https://github.com/Owl-Maintain/brlaser/archive/refs/tags/v6.2.8.tar.gz"
  sha256 "16dae855aa7fff0eef0c05398fab37678243d7d610fa5f9af0d3a2cc9bf08cb0"
  license "GPL-2.0-or-later"

  depends_on "cmake" => :build
  uses_from_macos "cups"

  deny_network_access!

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args,
           "-DCUPS_SERVER_BIN=#{libexec}/cups",
           "-DCUPS_DATA_DIR=#{share}/cups"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Generate the model PPDs and point their filter at the Homebrew-installed
    # binary. CUPS accepts an absolute path for the filter program.
    system "ppdc", "-d", "ppd", "build/brlaser.drv"
    inreplace Dir["ppd/*.ppd"] do |s|
      s.gsub!(" 33 rastertobrlaser", " 33 #{opt_libexec}/cups/filter/rastertobrlaser")
    end
    (share/"cups/ppd").install Dir["ppd/*.ppd"]
  end

  def caveats
    <<~EOS
      CUPS only runs filters owned by root, so the driver is not usable until
      it is copied into the system CUPS directories:

        sudo cp #{opt_libexec}/cups/filter/rastertobrlaser /usr/libexec/cups/filter/
        sudo cp #{opt_share}/cups/ppd/*.ppd /Library/Printers/PPDs/Contents/Resources/
        sudo launchctl stop org.cups.cupsd
        sudo launchctl start org.cups.cupsd

      Then add your Brother printer in System Settings > Printers & Scanners
      and look for entries marked "brlaser".

      Re-run these commands after each Homebrew upgrade.
    EOS
  end

  test do
    filter = libexec/"cups/filter/rastertobrlaser"
    assert_predicate filter, :executable?
    assert_match "brlaser version #{version}", shell_output("#{filter} 2>&1", 1)

    assert_path_exists share/"cups/drv/brlaser.drv"
    ppds = Pathname.glob(share/"cups/ppd/*.ppd")
    refute_empty ppds
    ppds.each do |ppd|
      assert_match "#{opt_libexec}/cups/filter/rastertobrlaser", ppd.read
    end
  end
end
