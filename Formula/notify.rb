class Notify < Formula
  desc "Stream the output of any CLI and publish it to a variety of supported platforms"
  homepage "https://github.com/projectdiscovery/notify"
  url "https://github.com/projectdiscovery/notify/archive/refs/tags/v1.0.5.tar.gz"
  sha256 "15824bee28cb9f3e74aa34559619fdceb865182fe12961d6c5cfc26db642b38c"
  license "MIT"
  head "https://github.com/projectdiscovery/notify.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a98b613b397408f9064059db3cb9d395d00c34f60e5b47195f2a3d3442be76f0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a98b613b397408f9064059db3cb9d395d00c34f60e5b47195f2a3d3442be76f0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a98b613b397408f9064059db3cb9d395d00c34f60e5b47195f2a3d3442be76f0"
    sha256 cellar: :any_skip_relocation, ventura:        "4ab287f6289bd0e830b3e599c7b886d6399c95639712edf5e6e972b37cf8cdb8"
    sha256 cellar: :any_skip_relocation, monterey:       "4ab287f6289bd0e830b3e599c7b886d6399c95639712edf5e6e972b37cf8cdb8"
    sha256 cellar: :any_skip_relocation, big_sur:        "4ab287f6289bd0e830b3e599c7b886d6399c95639712edf5e6e972b37cf8cdb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "62de427da765f4b2b26e38f055a5adf2fdf2c01410e7c2115786618b4cc7c6ec"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/notify"
  end

  test do
    assert_match "Current Version: #{version}", shell_output("#{bin}/notify --version 2>&1")
    assert_predicate testpath/".config/notify/config.yaml", :exist?
  end
end
