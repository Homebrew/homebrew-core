class ConsulBackinator < Formula
  desc "Consul backup and restoration application"
  homepage "https://github.com/myENA/consul-backinator"
  url "https://github.com/myENA/consul-backinator/archive/v1.3.tar.gz"
  sha256 "758bcea415c7a0f2c7aed1d095d10663b6927e7de8f60fbfdee83b94dd020eac"
  head "https://github.com/myENA/consul-backinator.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c914e71ca8264161eb4e348c6a75f139e253dbfcc892fa38852d82dd6fd8f39a" => :sierra
    sha256 "92da0359797f54d0df46d0c6643bd211efa63859dc030deaa3f84b8e5283a2c0" => :el_capitan
    sha256 "43955e5ae63b5122bd3b0a529f2d0b6c3e820e7409d1c0a9bb600fa2e77b10cf" => :yosemite
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
