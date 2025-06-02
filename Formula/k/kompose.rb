class Kompose < Formula
  desc "Tool to move from `docker-compose` to Kubernetes"
  homepage "https://kompose.io/"
  url "https://github.com/kubernetes/kompose/archive/refs/tags/v1.36.0.tar.gz"
  sha256 "b97616e412f29b7bc7a7a6431f27c9ad565c05298f7927d9bb588321e5da53d7"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kompose.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "328f85907fa8a4e2f36c434d441ab901181d36da837163eb9d7b24880f338236"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "328f85907fa8a4e2f36c434d441ab901181d36da837163eb9d7b24880f338236"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "328f85907fa8a4e2f36c434d441ab901181d36da837163eb9d7b24880f338236"
    sha256 cellar: :any_skip_relocation, sonoma:        "0f1963be82154e27dcf9be0340ad8636d4b13905cf67b4d8ba6226d5d0930557"
    sha256 cellar: :any_skip_relocation, ventura:       "0f1963be82154e27dcf9be0340ad8636d4b13905cf67b4d8ba6226d5d0930557"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6de242b6fdabbff5cf33b7e409bc17e1062fafa575e42d4305e3dcf9523af22f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"kompose", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kompose version")
  end
end
