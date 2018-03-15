class ConsulBackinator < Formula
  desc "Consul backup and restoration application"
  homepage "https://github.com/myENA/consul-backinator"
  url "https://github.com/myENA/consul-backinator/archive/v1.6.4.tar.gz"
  sha256 "8d47b754a445bbdc33da859d6778b05b9fa4c1f85e7c407fc7c95a3d9e9254b6"
  head "https://github.com/myENA/consul-backinator.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6b97666f8133df6ffe7622cc7deea1f392e72321b4b22d0e548b78d4a452bd51" => :high_sierra
    sha256 "806ba24558ff65826fa3677f06eccb6c891156ccd2463ed1ca33b2e75be2b8df" => :sierra
    sha256 "e8fda18dfa4256fccff3ac57fdb844594ee7ae15ae2e81acd1a4a8b15fe3deea" => :el_capitan
  end

  depends_on "go" => :build
  depends_on "glide" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GLIDE_HOME"] = HOMEBREW_CACHE/"glide_home/#{name}"

    dir = buildpath/"src/github.com/myENA/consul-backinator"
    dir.install buildpath.children

    cd dir do
      system "glide", "install"
      system "go", "build", "-v", "-ldflags",
             "-X main.appVersion=#{version}", "-o",
             bin/"consul-backinator"
      prefix.install_metafiles
    end
  end

  test do
    output = shell_output("#{bin}/consul-backinator --version 2>&1")
    assert_equal version.to_s, output.strip
  end
end
