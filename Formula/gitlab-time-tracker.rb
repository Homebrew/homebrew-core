require "language/node"

class GitlabTimeTracker < Formula
  desc "Command-line interface for GitLab's time tracking feature"
  homepage "https://github.com/kriskbx/gitlab-time-tracker"
  url "https://github.com/kriskbx/gitlab-time-tracker/releases/download/1.7.30/gtt-macos"
  sha256 "f3b4dd2ef1a938e1ee514a704d16e509fc671b48a1728f7857b817a589df17d7"


  def install
    chmod 0755, "gtt-macos"
    (libexec/"bin").install "gtt-macos"
    bin.install_symlink "#{libexec}/bin/gtt-macos" => bin/"gtt"
  end

  test do
    assert_match /#{version}/, shell_output("#{bin}/gtt --version")
  end
end
