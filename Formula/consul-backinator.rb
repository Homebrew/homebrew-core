class ConsulBackinator < Formula
  desc "Consul backup and restoration application"
  homepage "https://github.com/myENA/consul-backinator"
  url "https://github.com/myENA/consul-backinator/archive/v1.5.tar.gz"
  sha256 "cff9aa319ac5081098ccef685a5e141707ad041ab228b8eebfde86ef566f680a"
  head "https://github.com/myENA/consul-backinator.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "12116c450bd509dd6f9abf23f29fe2eb0905f1776c53af703c80868de1ffaa6b" => :sierra
    sha256 "4d58e1dff579429de8772e1f7fe04ed8f2bfe8c66d8538548cbed039560e7c38" => :el_capitan
    sha256 "6722622aaf962998842eb682d591b9a3af9321b96dcf03efff4f0f3b6e1a950d" => :yosemite
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
