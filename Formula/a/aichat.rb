class Aichat < Formula
  desc "ChatGPT cli"
  homepage "https://github.com/sigoden/aichat"
  url "https://github.com/sigoden/aichat/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "4713e650f0898b927c1d61f61c9b2871612956c416c8b45a3e213b69f7455996"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/sigoden/aichat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ea478e61c8770403e805d66f23eba181580982c4e68bf90ef1bb3d9fea926806"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "32122f5a79087cc63afe4d2139a3f6784026b2a5cb92cc2dc54f9d4db73f5712"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f5aef2c3bc8818d0b2ab55b7d0b06dfc46e4da0127290fd2208f7e2e50705037"
    sha256 cellar: :any_skip_relocation, sonoma:         "14157e5ac5ca4d0c98e5e7ddeef60319f2b6570b875ee6aa50e41af9ed5c2647"
    sha256 cellar: :any_skip_relocation, ventura:        "565d32356bc9a6ffdfa01e227fbca929e9f57c48eeaa97d310bbae7ff739729d"
    sha256 cellar: :any_skip_relocation, monterey:       "575540f6fe45d6c72554e9b579b31359517472f1c2e2858e20424758258c182e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a19989c054e99fabf3f8cde26cff6aa11fb577a5cb5864753ff8b63dcf69cf2"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV["OPENAI_API_KEY"] = "sk-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
    output = shell_output("#{bin}/aichat --dry-run math 3.2x4.8")
    assert_match "math 3.2x4.8", output
  end
end
