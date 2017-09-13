class ConsulBackinator < Formula
  desc "Consul backup and restoration application"
  homepage "https://github.com/myENA/consul-backinator"
  url "https://github.com/myENA/consul-backinator/archive/v1.6.2.tar.gz"
  sha256 "e3697d1f42f6aadf54824f5dfcad08956ca75135b62d1ba7982152d8b4ad529c"
  head "https://github.com/myENA/consul-backinator.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "354c3497e33d5c09e7b0d6aa635af387412facd8d3bd700781714199aea29a65" => :sierra
    sha256 "13447c998681eb2f334af03fd14b5fa6566c4c728e0f3083f0897d3ad33fcafd" => :el_capitan
    sha256 "efe3d460c5c8ed340aaa876d02c3b4463a22562370ddec6fc9ff9282f5ed5060" => :yosemite
  end

  depends_on "go" => :build
  depends_on "glide" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GLIDE_HOME"] = HOMEBREW_CACHE/"glide_home/#{name}"

    dir = buildpath/"src/github.com/myENA/consul-backinator"
    dir.install buildpath.children

    cd dir do
      system "glide", "install", "-v"
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
