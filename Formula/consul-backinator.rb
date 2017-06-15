class ConsulBackinator < Formula
  desc "Consul backup and restoration application"
  homepage "https://github.com/myENA/consul-backinator"
  url "https://github.com/myENA/consul-backinator/archive/v1.6.1.tar.gz"
  sha256 "c5635f445657ab47d3d1e76fd649aa89bba7d991061f64c8b34b074bd0e71775"
  head "https://github.com/myENA/consul-backinator.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "457755196f443139e556a8b27c1da973d1113fc7ae0d0ecf29644a7f52ba5faf" => :sierra
    sha256 "4122a459c57f6e9fd3b4aadd9e9db7b78131fa22443e94e6b7114babca292f25" => :el_capitan
    sha256 "98d2dd63f34f55cb472422c7a67cd5e851d8a24d72bc24df027f32b8294c903a" => :yosemite
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
