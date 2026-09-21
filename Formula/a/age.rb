class Age < Formula
  desc "Simple, modern, secure file encryption"
  homepage "https://github.com/FiloSottile/age"
  url "https://github.com/FiloSottile/age/archive/refs/tags/v1.3.2.tar.gz"
  sha256 "b07c28c6c4bdafa272073a310b75bc22c49da8904585a89c30e5ca4233e63843"
  license "BSD-3-Clause"
  head "https://github.com/FiloSottile/age.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ab6acf805fc7c3bd78da358bd3e4b3d4df3cabf6d070e5cc86745643012a4ee0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "48bbd797cd00ab11ec496717f51205ba07f4f7fdc7c8a939c5f4b7b6a11d5287"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "48bbd797cd00ab11ec496717f51205ba07f4f7fdc7c8a939c5f4b7b6a11d5287"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "48bbd797cd00ab11ec496717f51205ba07f4f7fdc7c8a939c5f4b7b6a11d5287"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "09fbfab1b5c6a27c3c44a4436c50436ca1dfe261ecd9a396c5fe840c05f72d22"
    sha256 cellar: :any,                 x86_64_linux:      "5f08c602724d0d9ad66f633301d209ee5ed81c160addd46779f08a0b83442ef1"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.Version=v#{version}"
    (buildpath/"cmd").each_child(false) do |cmd|
      system "go", "build", *std_go_args(ldflags:, output: bin/cmd), "./cmd/#{cmd}"
    end

    man1.install "doc/age.1"
    man1.install "doc/age-keygen.1"
  end

  test do
    system bin/"age-keygen", "-o", "key.txt"
    pipe_output("#{bin}/age -e -i key.txt -o test.age", "test", 0)
    assert_equal "test", shell_output("#{bin}/age -d -i key.txt test.age")
  end
end
