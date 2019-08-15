class Lazydocker < Formula
  desc "The lazier way to manage everything docker"
  homepage "https://github.com/jesseduffield/lazydocker"
  url "https://github.com/jesseduffield/lazydocker.git",
      :tag      => "v0.7",
      :revision => "2b6a4b02e5d56547c589dc071ecbef9efe4b20c9"

  bottle do
    cellar :any_skip_relocation
    sha256 "c9c5e85a792f4808beaecdad4e4022bd64af6988594a6b10765591d897742599" => :mojave
    sha256 "c6b6e912f30ea2c75860fc210d2fc16bc8b900955ecbaf7c113e30e63e78cc8a" => :high_sierra
    sha256 "e626c18457d25c667e79a89d1d59af29bf79bd7b19b9034d1a6451a905a3c6b2" => :sierra
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
