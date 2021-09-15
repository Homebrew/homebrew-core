class Minimesos < Formula
  desc "Testing infrastructure for Mesos frameworks"
  homepage "https://minimesos.org/"
  url "https://github.com/ContainerSolutions/minimesos/archive/0.13.0.tar.gz"
  sha256 "806a2e7084d66431a706e365814fca8603ba64780ac6efc90e52cbf7ef592250"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ed75cc748a76989016cc7cc69e07baf1b82eb9b6c2b5a16482fa289b733a8dc1"
    sha256 cellar: :any_skip_relocation, big_sur:       "630f067087841be66ac8118b072d4619c4aa1c3e28f07f6ac48c2b94483a164a"
    sha256 cellar: :any_skip_relocation, catalina:      "630f067087841be66ac8118b072d4619c4aa1c3e28f07f6ac48c2b94483a164a"
    sha256 cellar: :any_skip_relocation, mojave:        "630f067087841be66ac8118b072d4619c4aa1c3e28f07f6ac48c2b94483a164a"
  end

  deprecate! date: "2018-06-22", because: :repo_archived

  def install
    bin.install "bin/minimesos"
  end

  test do
    output = shell_output("#{bin}/minimesos --help 2>&1", 127)
    assert_match "docker: command not found", output
  end
end
