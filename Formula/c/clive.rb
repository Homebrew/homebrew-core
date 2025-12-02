class Clive < Formula
  desc "Automates terminal operations"
  homepage "https://github.com/koki-develop/clive"
  url "https://github.com/koki-develop/clive/archive/refs/tags/v0.12.15.tar.gz"
  sha256 "5d729b0a31a404fb45a3cf1533a5afaf5bb673bc721a6334dd0e1c1baeaf73ce"
  license "MIT"
  head "https://github.com/koki-develop/clive.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1e9bddcebb85074a61d1ab0621060b97a7281545bdcc806c8475163028dd4279"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e9bddcebb85074a61d1ab0621060b97a7281545bdcc806c8475163028dd4279"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e9bddcebb85074a61d1ab0621060b97a7281545bdcc806c8475163028dd4279"
    sha256 cellar: :any_skip_relocation, sonoma:        "7a6edfb2d3cae0477e8e9ea6ed14b3aecb1280063affb8bba8932c1946d4bcb1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cd0a3d1ad9f7c9d4eec81d8e835a6c67c833aeff22fbe135ee22d3f7945b7945"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3c6fefb061d3c4f06a31762399a72ea00e189c6b27f9a89eb4da6941fa4528d"
  end

  depends_on "go" => :build
  depends_on "ttyd"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/koki-develop/clive/cmd.version=v#{version}")
  end

  test do
    system bin/"clive", "init"
    assert_path_exists testpath/"clive.yml"

    system bin/"clive", "validate"
    assert_match version.to_s, shell_output("#{bin}/clive --version")
  end
end
