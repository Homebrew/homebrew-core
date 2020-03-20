class GitProfile < Formula
  desc "Simple user profile manager for git"
  homepage "https://github.com/bobbo/git-profile"
  url "https://github.com/bobbo/git-profile/archive/v0.1.0.tar.gz"
  sha256 "999404c4872d5af9b3fbb651337617fdc5ab075015267a64ae044cb14ff12ea1"
  head "https://github.com/bobbo/git-profile.git"

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    major, minor = version.to_s.split(".")
    assert_match "git-profile #{major}.#{minor}",
                 shell_output("#{bin}/git-profile --version")
  end
end
