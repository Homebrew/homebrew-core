class ConsulBackinator < Formula
  desc "Consul backup and restoration application"
  homepage "https://github.com/myENA/consul-backinator"
  url "https://github.com/myENA/consul-backinator/archive/v1.3.tar.gz"
  sha256 "758bcea415c7a0f2c7aed1d095d10663b6927e7de8f60fbfdee83b94dd020eac"
  head "https://github.com/myENA/consul-backinator.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c7e52f5347d4b23613a563ccb874ef3fc7e737efb084d30cc05d1275943ea6a0" => :sierra
    sha256 "f1398d10060aefe9a0473a0a8118a4a218894128b336ade9301b48251ecd5a22" => :el_capitan
    sha256 "f645cd817c61432acc1a307899d2eddbd3227d7b4d3b8983ae3b811d9fae3c04" => :yosemite
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
    output = shell_output("#{bin}/consul-backinator --version 2>&1", 1)
    assert_equal version.to_s, output.strip
  end
end
