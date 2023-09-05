class Gokart < Formula
  desc "Static code analysis for securing Go code"
  homepage "https://github.com/praetorian-inc/gokart"
  url "https://github.com/praetorian-inc/gokart/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "81bf1e26531117de4da9b160ede80aa8f6c4d4984cc1d7dea398083b8e232eb7"
  license "Apache-2.0"
  head "https://github.com/praetorian-inc/gokart.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3adae6ff7cc756f194a906f77d25a0d4680cb69241c670c3b3b36323c69ce39f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "50f225b023198e9ecb44e854f37cd84c0638cb17bef5b1d43bcb31a2bb8d58d0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "01ab4e67e745df4737e271c3d1639bd02c5ab1b028c3ad10e6a227c41ffd99bf"
    sha256 cellar: :any_skip_relocation, ventura:        "1a2bc072f4a20991d7bfd81876fded10bd3bf87919e61ef63f217d468ccd6464"
    sha256 cellar: :any_skip_relocation, monterey:       "6b738132eca3d46d45bac4940af5edf356150bf8b0b693e195d77b0a8de0f5f4"
    sha256 cellar: :any_skip_relocation, big_sur:        "0b8950ba85b71dd420699eff09b64251473c2b0b130c5c2bcc530afd6a8b0a30"
    sha256 cellar: :any_skip_relocation, catalina:       "4bdf138ac774192e8984fbe34033c0673a4e0a8f173441ede2af1c1cf3ab2f20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "272ab63250f847c8749b0ea407a5947e8472288f8bb21da400df45a01e9ecb4a"
  end

  depends_on "go" => [:build, :test]

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    mkdir "brewtest" do
      system "go", "mod", "init", "brewtest"
      (testpath/"brewtest/main.go").write <<~EOS
        package main

        func main() {}
      EOS
    end

    assert_match "GoKart found 0 potentially vulnerable functions",
      shell_output("#{bin}/gokart scan brewtest")

    assert_match version.to_s, shell_output("#{bin}/gokart version")
  end
end
