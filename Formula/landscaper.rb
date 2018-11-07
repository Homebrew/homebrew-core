class Landscaper < Formula
  desc "Manage the application landscape in a Kubernetes cluster"
  homepage "https://github.com/Eneco/landscaper"
  url "https://github.com/Eneco/landscaper.git",
      :tag      => "v1.0.21",
      :revision => "df2a7d6a7db7a552576899b9fe8c85fdcc0af973"
  head "https://github.com/Eneco/landscaper.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3dd194cffc08bae1f2c198fd9e00754dfb50d8b5cdd0b2919c2d264e036fdd52" => :mojave
    sha256 "3178fa78ef23e83c5c13434e653e32b396331bbd453c723c715f3391580f9c89" => :high_sierra
    sha256 "9ad4b178600bab7a562ee65685fc410731cd9b6af8c07d5b85820d46bb74ac9c" => :sierra
  end

  depends_on "dep" => :build
  depends_on "go" => :build
  depends_on "kubernetes-cli"
  depends_on "kubernetes-helm"

  def install
    ENV["GOPATH"] = buildpath
    ENV.prepend_create_path "PATH", buildpath/"bin"
    arch = MacOS.prefer_64_bit? ? "amd64" : "x86"
    ENV["TARGETS"] = "darwin/#{arch}"
    dir = buildpath/"src/github.com/eneco/landscaper"
    dir.install buildpath.children - [buildpath/".brew_home"]

    cd dir do
      system "make", "bootstrap"
      system "make", "build"
      bin.install "build/landscaper"
      prefix.install_metafiles
    end
  end

  test do
    assert_match "This is Landscaper v#{version}", pipe_output("#{bin}/landscaper apply 2>&1")
  end
end
