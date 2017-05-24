class ConsulBackinator < Formula
  desc "Consul backup and restoration application"
  homepage "https://github.com/myENA/consul-backinator"
  url "https://github.com/myENA/consul-backinator/archive/v1.6.tar.gz"
  sha256 "f239f140616e0f4294c20e85089cc42f5d9e2bd20bca1a4c625434c0c50d3eed"
  head "https://github.com/myENA/consul-backinator.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "bf600bf9d40bc837ac4f104c9aa5779d326ccf445719e248f1580736a1c99789" => :sierra
    sha256 "b20de7f33c69f67351538d74ef36e68f6428c57cd896f8e85db116e1d25b9368" => :el_capitan
    sha256 "69ece1601c9e539ad41c5472de6b67443529bb51b049e798ab208b137d8fd7c8" => :yosemite
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
