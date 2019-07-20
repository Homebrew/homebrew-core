class Lazydocker < Formula
  desc "The lazier way to manage everything docker"
  homepage "https://github.com/jesseduffield/lazydocker"
  url "https://github.com/jesseduffield/lazydocker.git",
      :tag      => "v0.6.4",
      :revision => "8970352efc4a046c01de6263b1a9ecd271ef29fc"

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
