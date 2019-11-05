class Ghq < Formula
  desc "Remote repository management made easy"
  homepage "https://github.com/motemen/ghq"
  url "https://github.com/motemen/ghq.git",
      :tag      => "v0.12.8",
      :revision => "fe5ca0511e4d028be926215d05590638e3995c99"
  head "https://github.com/motemen/ghq.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d15de30dd7e7d69793fe51f39533c6ad94aaf8b5625005fd6bcb361b0b525286" => :catalina
    sha256 "debe943bcf47ae9b8f78747e24557c5356d57f4f9ed3206cae48d5e15022c871" => :mojave
    sha256 "8bb287986b310cd0ab87c790b292b8831a9e93a31df78752ef35eb5819ee4fc1" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    bin.install "ghq"
    zsh_completion.install "zsh/_ghq"
    prefix.install_metafiles
  end

  test do
    assert_match "#{testpath}/.ghq", shell_output("#{bin}/ghq root")
  end
end
