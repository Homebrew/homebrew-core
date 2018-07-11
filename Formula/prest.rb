class Prest < Formula
  desc "Serve a RESTful API from any PostgreSQL database"
  homepage "https://github.com/prest/prest"
  url "https://github.com/prest/prest/archive/v0.3.3.tar.gz"
  sha256 "dbadb08c44ddf43b4cffe2845efe3def91a6254d27193d8a4968632a13959215"

  bottle do
    cellar :any_skip_relocation
    sha256 "d29db7af3359e62274c1756f63ab4b401c93fcaca3d4299e970dc155cb9fdb68" => :high_sierra
    sha256 "7243715a491111ecaab69eee85ea0f6b6b9fc06d6ea9aa55fa964e521f72dfc1" => :sierra
    sha256 "104ae54713231e8a6b06612a763c98564f9d43a2eeb6e2676f145f34c1151cdc" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/prest/prest").install buildpath.children
    cd "src/github.com/prest/prest" do
      system "go", "build", "-ldflags",
             "-X github.com/prest/prest/vendor/github.com/prest/helpers.PrestVersionNumber=#{version}",
             "-o", bin/"prest"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/prest version")
  end
end
