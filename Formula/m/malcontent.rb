class Malcontent < Formula
  desc "Supply Chain Attack Detection, via context differential analysis and YARA"
  homepage "https://github.com/chainguard-dev/malcontent"
  url "https://github.com/chainguard-dev/malcontent/archive/refs/tags/v1.21.3.tar.gz"
  sha256 "5a3e938a2c8bc66d616256118971505ca43b2f38b7d1c1f73890072cfcd5c1aa"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/malcontent.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "af9947d93b278211d8efe4261f7b91d9acc9ce4591af13a5f71df8802c328f5a"
    sha256 cellar: :any,                 arm64_sequoia: "48161b24966632a756809d127929a594ae1bdc568e6c5d8c43f04f94f112e40f"
    sha256 cellar: :any,                 arm64_sonoma:  "2fd61dc3bb6f1f20329d7608ea06b39f57d180bd6c6dc2b5b01d8f02bd26bab1"
    sha256 cellar: :any,                 sonoma:        "04fdc3e6bf1afad3c22fd7c030928857c45c1be7a97e7b47769e13597b6043b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "96bb01dbb5ea67bb547e98ff42623e9b50aeeac2967bf107cbdcf0cc172189e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d62799d1082fbc56d0418457c895abd71dc70296513f4d844ad818bd8e30fd3"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "yara-x"

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    system "go", "build", *std_go_args(ldflags: "-s -w -X main.BuildVersion=#{version}", output: bin/"mal"), "./cmd/mal"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mal --version")

    (testpath/"test.py").write <<~PYTHON
      import subprocess
      subprocess.run(["echo", "execute external program"])
    PYTHON

    assert_match "program — execute external program", shell_output("#{bin}/mal analyze #{testpath}")
  end
end
