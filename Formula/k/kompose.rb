class Kompose < Formula
  desc "Tool to move from `docker-compose` to Kubernetes"
  homepage "https://kompose.io/"
  url "https://github.com/kubernetes/kompose/archive/v1.31.1.tar.gz"
  sha256 "93a17b6a7e2515f0fe0ec8881d266b45bac8463d6810428edfd8ec38df0d8717"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "567422c2a937d7135586dfc0ec94dd3db5dc017fcbf67b5d12bc4d265ec63a77"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ef9a48a23eb589bc40d282192eb944e6142ead05ee4b50344018bd7581bcc361"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "654f5162a23266c587860824061a11c6766afa4b17223b54b862c00c07ae290a"
    sha256 cellar: :any_skip_relocation, sonoma:         "8fbd9915a35f69d589d3bfecae716b71de3c0567cc878a9bdcd4338e33c8f39b"
    sha256 cellar: :any_skip_relocation, ventura:        "836415779c0789765868922fa9157d906e30ed36c8022a0262ff348173b5b92d"
    sha256 cellar: :any_skip_relocation, monterey:       "578e0eb6132e782feaf876f3bde3bf5bc90ff594e00d81f052217701a10e1be3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a4e21c06b0c0657f4d1b439aa1932b13d4b5329b9c65b125bbe9e61d98ab219"
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
