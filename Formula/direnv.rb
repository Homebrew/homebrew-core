class Direnv < Formula
  desc "Load/unload environment variables based on $PWD"
  homepage "https://direnv.net/"
  url "https://github.com/direnv/direnv/archive/v2.15.0.tar.gz"
  sha256 "efabc88a7556d75e9ac0245d51fdf2a4464122865fb0daf8a103ff5608ecd8b9"
  head "https://github.com/direnv/direnv.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1dd24f6c9cb5082091f62a9a98aef11305e7a5f5d545d8368de421f0179318d4" => :high_sierra
    sha256 "642d28694bda5a4471919a5b73709eb8da6655e188f58640b13d95da3aecb973" => :sierra
    sha256 "257cba635f99eb52ba20be9558fe20fd67040cef64b758106a48ea241d500b72" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/direnv/direnv").install buildpath.children
    cd "src/github.com/direnv/direnv" do
      system "make", "install", "DESTDIR=#{prefix}"
      prefix.install_metafiles
    end
  end

  test do
    system bin/"direnv", "status"
  end
end
