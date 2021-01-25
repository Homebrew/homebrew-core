class Ghq < Formula
  desc "Remote repository management made easy"
  homepage "https://github.com/x-motemen/ghq"
  url "https://github.com/x-motemen/ghq.git",
      tag:      "v1.1.5",
      revision: "f5ac3e5655ced9bf3aee2690a2aaa43431cc567f"
  license "MIT"
  head "https://github.com/x-motemen/ghq.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "65c3fa300e2dc1f8e20634feb2acb60b7ba2ee9aa17a87dab39acafd4869246d" => :big_sur
    sha256 "4b20b63da37b5c05ef8b0da54015a6f16fa08d43ed32920cd980b8243be22967" => :arm64_big_sur
    sha256 "247f4e7b0964b0a27321b24ae06349d9eac65280345dda17680fa8049c29ac75" => :catalina
    sha256 "a863be3a3b307c82821d0dbed2d4d1faa05aaea9c6dd150d7b3f2a878e4bd79c" => :mojave
    sha256 "060f3bc0d7b55e04274383faa21b45e8d8457ca61e25fd3416b2fe0d3177036b" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "make", "build", "VERBOSE=1"
    bin.install "ghq"
    bash_completion.install "misc/bash/_ghq" => "ghq"
    zsh_completion.install "misc/zsh/_ghq"
    prefix.install_metafiles
  end

  test do
    assert_match "#{testpath}/ghq", shell_output("#{bin}/ghq root")
  end
end
