class Prest < Formula
  desc "Serve a RESTful API from any PostgreSQL database"
  homepage "https://github.com/nuveo/prest"
  url "https://github.com/nuveo/prest/archive/v0.3.0.tar.gz"
  sha256 "a8fef456abc47a34aedb05d95c4b9a64d2f7f306016cb789f2b0de9229f5d3f3"

  bottle do
    cellar :any_skip_relocation
    sha256 "121d5011565aaf4ff020bf749c8adf8c7e7b91490a30bea209409567b3f9dcbd" => :high_sierra
    sha256 "1389d9555bf9bd94dc61e97f04bb35b14467153f9618c9068ce8e38e62799cb7" => :sierra
    sha256 "ea5fb9b002f4e0c6fb8d39c17ea3e6d7d2a6877631f40b05415c6a24cfd7a4ad" => :el_capitan
    sha256 "3ac2e78d1868362a2ac2acb1b9f478d2837b915d75eec9981a92a4c96f773e13" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/nuveo/prest").install buildpath.children
    cd "src/github.com/nuveo/prest" do
      system "go", "build", "-o", bin/"prest"
      prefix.install_metafiles
    end
  end

  test do
    system "#{bin}/prest", "version"
  end
end
