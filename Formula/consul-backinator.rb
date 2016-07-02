class ConsulBackinator < Formula
  desc "Consul backup and restoration application"
  homepage "https://github.com/myENA/consul-backinator"
  url "https://github.com/myENA/consul-backinator.git",
    :tag => "v1.0",
    :revision => "c07989a0cf4f18d4401d6975c48513ffa7db6d5d"
  head "https://github.com/myENA/consul-backinator.git"

  depends_on "go" => :build
  depends_on "glide" => :build

  def install
    ENV["GOPATH"] = buildpath

    dir = buildpath/"src/github.com/myENA/consul-backinator"
    dir.install buildpath.children

    ENV.prepend_create_path "PATH", buildpath/"bin"

    cd dir do
      system "./build.sh", "-i"
      bin.install "consul-backinator"
    end
  end

  test do
    ## testing requires access consul
  end
end
