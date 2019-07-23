class Octant < Formula
  desc "A web-based, highly extensible platform for developers to better understand the complexity of Kubernetes clusters."
  homepage "https://github.com/vmware/octant"
  url "https://github.com/vmware/octant.git",
      :tag      => "v0.4.0",
      :revision => "f3702d9a64ba228b4ffa1c81b37be34780b1cf47"
  head "https://github.com/vmware/octant.git"

  depends_on "go" => :build
  depends_on "node@10" => :build
  depends_on "protoc-gen-go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "on"
    ENV["GOFLAGS"] = "-mod=vendor"

    dir = buildpath/"src/github.com/vmware/octant"
    dir.install buildpath.children

    cd "src/github.com/vmware/octant" do
      system "make", "go-install"
      ENV.prepend_path "PATH", buildpath/"bin"

      system "make", "web-build"
      system "make", "generate"

      commit = Utils.popen_read("git rev-parse HEAD").chomp
      build_time = Utils.popen_read("date -u +'%Y-%m-%dT%H:%M:%SZ' 2> /dev/null").chomp
      ldflags = ["-X \"main.version=#{version}\"",
                 "-X \"main.gitCommit=#{commit}\"",
		 "-X \"main.buildTime=#{build_time}\""]

      system "go", "build", "-o", bin/"octant", "-ldflags", ldflags.join(" "),
	      "-v", "./cmd/octant"
    end
  end

  test do
    system "#{bin}/octant", "version"
  end
end
