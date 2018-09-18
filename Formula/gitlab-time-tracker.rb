require "language/node"

class GitlabTimeTracker < Formula
  desc "Command-line interface for GitLab's time tracking feature"
  homepage "https://github.com/kriskbx/gitlab-time-tracker"
  url "https://registry.npmjs.org/gitlab-time-tracker/-/gitlab-time-tracker-1.7.27.tgz"
  sha256 "a29b7be0069201688dab67280fa681a1698db80f1f2abab18af962bedf960871"

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match /#{version}/, shell_output("#{bin}/gtt --version")
  end
end
