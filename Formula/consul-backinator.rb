class ConsulBackinator < Formula
  desc "Consul backup and restoration application"
  homepage "https://github.com/myENA/consul-backinator"
  url "https://github.com/myENA/consul-backinator/archive/v1.5.tar.gz"
  sha256 "cff9aa319ac5081098ccef685a5e141707ad041ab228b8eebfde86ef566f680a"
  head "https://github.com/myENA/consul-backinator.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5c48c87a299828960ef6152f2db35418b8f5242a9411f08d0d88e17ef911247c" => :sierra
    sha256 "69d2ae3dafba8cd1f1fc3c94885884518847e3a5fe47e11ae9a5da8101cbda6d" => :el_capitan
    sha256 "07933b258252bcf78d61959831b1088ff6bfd8cfa8988f23e8008b504a943472" => :yosemite
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
