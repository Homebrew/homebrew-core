class Procs < Formula
  desc "Modern replacement for ps written by Rust"
  homepage "https://github.com/dalance/procs"
  url "https://github.com/dalance/procs/archive/refs/tags/v0.14.6.tar.gz"
  sha256 "3d5cd529c858ca637b166bac908e0d8429c33bdfa9d8db6282f36d5732e4e30a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4403e855affce7f84a54fc32729e302d30324979ca3709653d1ffc22f8a5a13f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f4e55542abfdf250b389dbf60b7cfaa9363268c3e944aff27f9a82dc5dd28003"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ccd5d1466ad95922827367ecf97bb07ca1e5aa1a8fad0521b712cb1f5fc417cb"
    sha256 cellar: :any_skip_relocation, sonoma:         "2909d4628c4bf5843b2eab75f852441b8c56e24fc0b62c01e30d7265a2806621"
    sha256 cellar: :any_skip_relocation, ventura:        "4574390e642c603741eb0287f9e3981317adc6b5e8120f582ffd13bf67b48f4f"
    sha256 cellar: :any_skip_relocation, monterey:       "852537ba382ae6f8bc2b8d34b909b9605a1f4d03c1eb013f4e1f3d66129b3cb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "876c46b01fd03352905ed95b0d5a0cbf5e22b3b9ea9dc2e6150762d2b86fc7b4"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    system bin/"procs", "--gen-completion", "bash"
    system bin/"procs", "--gen-completion", "fish"
    system bin/"procs", "--gen-completion", "zsh"
    bash_completion.install "procs.bash" => "procs"
    fish_completion.install "procs.fish"
    zsh_completion.install "_procs"
  end

  test do
    output = shell_output(bin/"procs")
    count = output.lines.count
    assert count > 2
    assert output.start_with?(" PID:")
  end
end
