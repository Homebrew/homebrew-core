class Gosec < Formula
  desc "Golang security checker"
  homepage "https://securego.io/"
  url "https://github.com/securego/gosec/archive/refs/tags/v2.20.0.tar.gz"
  sha256 "19917c0b62778cbca86e98be806a114d534e3a56e567a7b7db645c8c856ca15e"
  license "Apache-2.0"
  head "https://github.com/securego/gosec.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "460df89242635a9b5d5a0419b9736bd6df13e711693f11f4fcac26e6035b411f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "44574ed94b5b906225c844685bf89066f3090e39deb6bc419b4167004330f209"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "02c81f4c172c12f18cec052033ab239a2d17c5a133993d79dbb9759d529f24e0"
    sha256 cellar: :any_skip_relocation, sonoma:         "b778e37ac633da31ea815f3a5ad82dc482f0eda027d6370275c2e5738969989d"
    sha256 cellar: :any_skip_relocation, ventura:        "16381ab0fe53432feb7815503ce14a0f968c258c7bb8bddf23620829d24422f2"
    sha256 cellar: :any_skip_relocation, monterey:       "10fa003cf01afb10adb3fe1bc74a13c8eef93c35769c86c14f790a36c14d0fac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "18092cad463d586173b7ca8e7b27e1ba8db1881d684594894e8b9cd350418006"
  end

  depends_on "go"

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=v#{version}"), "./cmd/gosec"
  end

  test do
    (testpath/"test.go").write <<~EOS
      package main

      import "fmt"

      func main() {
          username := "admin"
          var password = "f62e5bcda4fae4f82370da0c6f20697b8f8447ef"

          fmt.Println("Doing something with: ", username, password)
      }
    EOS

    output = shell_output("#{bin}/gosec ./...", 1)
    assert_match "G101 (CWE-798)", output
    assert_match "Issues : \e[1;31m1\e[0m", output
  end
end
