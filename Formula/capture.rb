class Capture < Formula
  desc "Command-line utility for creating media files from video/audio hardware"
  homepage "https://github.com/krad/capture/"
  url "https://github.com/krad/capture/archive/0.0.1.tar.gz"
  sha256 "cdec379de2832b0a21ad5f3b973685f4684a0926166e70ba147003838fb1285d"

  depends_on :xcode => ["9.0", :build]
  depends_on :macos => :sierra

  def install
    target_config = "release"
    system "swift", "build",
                    "--disable-sandbox",
                    "-c", target_config,
                    "-Xswiftc",
                    "-no-static-stdlib"

    get_build_path_cmd = ["swift",
                          "build",
                          "--show-bin-path",
                          "-c",
                          target_config].join(" ")

    build_dir   = `#{get_build_path_cmd}`.strip!
    path_to_lib = "#{build_dir}/libBuffie.dylib"
    path_to_bin = "#{build_dir}/capture"

    lib.install path_to_lib
    bin.install path_to_bin
  end

  test do
    assert_match "capture #{version}",
                 shell_output("#{bin}/capture").chomp
  end
end
