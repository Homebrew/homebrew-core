class Aliyunpan < Formula
  desc "Command-line client tool for Alibaba aDrive disk"
  homepage "https://github.com/tickstep/aliyunpan"
  url "https://github.com/tickstep/aliyunpan/archive/refs/tags/v0.3.8.tar.gz"
  sha256 "677cf7693d964ac6324f07f66b5ba46b1a287be80b9e2678710ab7a3c4085395"
  license "Apache-2.0"
  head "https://github.com/tickstep/aliyunpan.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2895d750b8c776cd0b7d9b5cc343ee6f60c31a4af82d5a620a9c834fcdf9b9d5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2895d750b8c776cd0b7d9b5cc343ee6f60c31a4af82d5a620a9c834fcdf9b9d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2895d750b8c776cd0b7d9b5cc343ee6f60c31a4af82d5a620a9c834fcdf9b9d5"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a71887221ca3045539c9eb62b76ed8b054630e3df107b79b714c224557b4e46"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4879106b40c7ded64aa3dc54022b1bc185bcfb8ae717a24f84a8b810a5745c60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d7730f0728b08b2c26780220bff930e382df30a500cc9612e3fdaa450eed83e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system bin/"aliyunpan", "run", "touch", "output.txt"
    assert_path_exists testpath/"output.txt"
  end
end
