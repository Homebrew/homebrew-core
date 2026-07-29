class Lazyrsync < Formula
  desc "Terminal UI for rsync with profiles, dry-run preview and live progress"
  homepage "https://lazyrsync.westpoint.io"
  url "https://github.com/westpoint-io/lazyrsync/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "4ce106e10a258ccb4fdf8958b49746f7a1f9386592ede441f620a7f41ffb7d75"
  license "MIT"
  head "https://github.com/westpoint-io/lazyrsync.git", branch: "main"

  depends_on "rust" => :build
  # macOS's openrsync lacks --itemize-changes, --info=progress2 and --link-dest,
  # which the preview, progress and snapshot features require
  depends_on "rsync"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"src").mkpath
    (testpath/"src/hello.txt").write "hello"
    (testpath/"config/lazyrsync").mkpath
    (testpath/"config/lazyrsync/profiles.toml").write <<~TOML
      [[profile]]
      name = "smoke"

      [[profile.task]]
      label  = "files"
      source = "#{testpath}/src/"
      dest   = "#{testpath}/dst/"
    TOML

    ENV["XDG_CONFIG_HOME"] = testpath/"config"

    assert_match "#{testpath}/src/", shell_output("#{bin}/lazyrsync list")
    assert_match "hello.txt", shell_output("#{bin}/lazyrsync run smoke -n")
    refute_path_exists testpath/"dst/hello.txt"

    assert_match version.to_s, shell_output("#{bin}/lazyrsync --version")
  end
end
