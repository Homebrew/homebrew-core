class Hut < Formula
  desc "CLI tool for sr.ht"
  homepage "https://sr.ht/~emersion/hut"
  url "https://git.sr.ht/~emersion/hut/archive/v0.4.0.tar.gz"
  sha256 "f25ab4452e4622f404a6fa5713e8505302bfcee4dd3a8dfe76f1fc4c05688c09"
  license "AGPL-3.0-or-later"
  head "https://git.sr.ht/~emersion/hut", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b47053ab6ab2282d079a77f13038b968f4d5a5013153ceab38d84d8b6392bedd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "09023523c6d8b2a3fcff4d422a14b6ffbf3ac6b2cad7bfbe3c991b74b64640e8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f7e4ea7db6f23034324cce71200a0605320b4b1d63b377c31e1b27428d4a5396"
    sha256 cellar: :any_skip_relocation, sonoma:         "508368f9fa0be4dc577eaabec87759637418dba20d39776e65dfeec7e142be59"
    sha256 cellar: :any_skip_relocation, ventura:        "e01c2de87ba26afbb727041d1f0753a740487d15428cd5a9639a5be2800ff1ae"
    sha256 cellar: :any_skip_relocation, monterey:       "ada83013f05a5ac336cd4a2cc1279c16aedda55f763f637592cab1005c6382f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a4d84fdf57a07bc5af4212ac26442497392b314efab0d2604bfade7fb491d78"
  end

  depends_on "go" => :build
  depends_on "scdoc" => :build

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"config").write <<~EOS
      instance "sr.ht" {
          access-token "some_fake_access_token"
      }
    EOS
    assert_match "Authentication error: Invalid OAuth bearer token",
      shell_output("#{bin}/hut --config #{testpath}/config todo list 2>&1", 1)
  end
end
