class Lazydocker < Formula
  desc "The lazier way to manage everything docker"
  homepage "https://github.com/jesseduffield/lazydocker"
  url "https://github.com/jesseduffield/lazydocker.git",
      :tag      => "v0.6.4",
      :revision => "8970352efc4a046c01de6263b1a9ecd271ef29fc"

  bottle do
    cellar :any_skip_relocation
    sha256 "86006230ee8228607c186151b53ce98b0a278b84c37d3ceefa9c01eccffa9670" => :mojave
    sha256 "7c72935345ba694428f1f340162add57266ce43299038178e5e9f4120b84194e" => :high_sierra
    sha256 "fe9a03784b52af6f9178a53d17925a0a4f319cee384a3c8560dc0b51aa52022a" => :sierra
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
