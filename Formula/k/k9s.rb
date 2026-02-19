class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https://k9scli.io/"
  url "https://github.com/derailed/k9s.git",
      tag:      "v0.50.18",
      revision: "6dbf571c59fd48dc5b384aa46ee7f3e5decfae2b"
  license "Apache-2.0"
  head "https://github.com/derailed/k9s.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "640c74ca18c9ccfbf9fc9f903223fb8b8acaefc07ed36e50c82324311b2dce95"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bd8d2d9b3d1514a4ae71f441f42974e699bda7bbce9640621802a55b5b7b6ed6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f6b82ca069e6ff73a5ab7cb6732f1e64abfbc127a10958c9ccd55d0740d94110"
    sha256 cellar: :any_skip_relocation, sonoma:        "48a6671360c2266758916b585748e18dfd2c359631c344cb0e005f4068d9be62"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "346696b92754e55d665b5c55ba3cca18b28b1c2696bbc331674b6502e5415b0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3752c9e54adb8cc77cf821ef3e952a89acac090681135bb2e42836515a2e20b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/derailed/k9s/cmd.version=#{version}
      -X github.com/derailed/k9s/cmd.commit=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"k9s", shell_parameter_format: :cobra)
  end

  test do
    assert_match "K9s is a CLI to view and manage your Kubernetes clusters.",
                 shell_output("#{bin}/k9s --help")
  end
end
