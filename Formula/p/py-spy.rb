class PySpy < Formula
  desc "Sampling profiler for Python programs"
  homepage "https://github.com/benfred/py-spy"
  url "https://github.com/benfred/py-spy/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "ecf8d945f63b172126abcd68e21f3e5f250498cb774d88247d80a6f2cacdb998"
  license "MIT"
  head "https://github.com/benfred/py-spy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e2d8e585ccde05e30101c3e05807b0eedcf8202ebeeb08c60d84c7c37f01a38e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cdaff3d95a476c9c109fb357f67704199bf5b755a92cfaa5c153aa67a2e72298"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d384def632170e7eda0fc52d3f3a1031a01c34bcdbede0597ab5db382f33a6ba"
    sha256 cellar: :any_skip_relocation, sonoma:        "022ed6e3642bc99a07d0ee2cb651e462d52ad38efc09d9b57e742ec1009f2fb6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dab65ae51452068513c73e6eab32f21c4063c9d112c6ca1008e1446e3fcc5023"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b5b4e93ddb2157cd288149650ec9b700244376a99e3f98463c64a1cd2b15643"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "python@3.13" => :test # https://github.com/benfred/py-spy/issues/750
    depends_on "libunwind"
  end

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"py-spy", "completions")
  end

  test do
    if OS.mac?
      output = shell_output("#{bin}/py-spy record python3 2>&1", 1)
      assert_match "Try running again with elevated permissions by going", output
    else
      python = "python3.13"
      output = shell_output("#{bin}/py-spy record -- #{python} -c 'import time; time.sleep(1)' 2>&1")
      assert_match(/Samples: \d+ Errors: 0/, output)
    end
  end
end
