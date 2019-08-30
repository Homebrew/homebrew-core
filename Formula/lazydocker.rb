class Lazydocker < Formula
  desc "The lazier way to manage everything docker"
  homepage "https://github.com/jesseduffield/lazydocker"
  url "https://github.com/jesseduffield/lazydocker.git",
      :tag      => "v0.7.1",
      :revision => "febfce995c852ca9d1977febc6098165f7e31c8f"

  bottle do
    cellar :any_skip_relocation
    sha256 "448c9b4760898d4a9dfe413c63ba87e00cf69beffebac8bb6f0cb306eb804015" => :mojave
    sha256 "c80c8aec321d2de15ced2bd7751b61051289afb6b878089fe08dc6f74e30c71f" => :high_sierra
    sha256 "c069bc79403e1ef934a220f1559c8ca5102075cc09b889a0197d0587fa70444d" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GO111MODULE"] = "on"
    ENV["GOPATH"] = buildpath

    dir = buildpath/"src/github.com/jesseduffield/lazydocker"
    dir.install buildpath.children

    cd dir do
      system "go", "build", "-mod", "vendor", "-ldflags", "-X main.version=#{version}", "-o", bin/"lazydocker"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lazydocker --version")

    assert_match "reporting: undetermined", shell_output("#{bin}/lazydocker --config")
  end
end
