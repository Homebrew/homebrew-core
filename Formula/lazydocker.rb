class Lazydocker < Formula
  desc "The lazier way to manage everything docker"
  homepage "https://github.com/jesseduffield/lazydocker"
  url "https://github.com/jesseduffield/lazydocker.git",
      :tag      => "v0.9.1",
      :revision => "10617da5608990bf4911142745d31566bac6964a"

  bottle do
    cellar :any_skip_relocation
    sha256 "51a269c04bf156039e05ebb721c34da808973aaa6b52f014d07af3e441e6ebe7" => :catalina
    sha256 "fc34436a43b43fb69c3f98e5c4a2dd26653b47a993f802eeac443ea1cfd2134d" => :mojave
    sha256 "2186290d630c746995a06f2e37e1f77d9bd6e77becee66d59f1e5fdeb5fc4703" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-mod=vendor", "-o", bin/"lazydocker",
      "-ldflags", "-X main.version=#{version} -X main.buildSource=homebrew"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lazydocker --version")

    assert_match "reporting: undetermined", shell_output("#{bin}/lazydocker --config")
  end
end
