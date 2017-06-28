class Landscaper < Formula
  desc "Manage the application landscape in a Kubernetes cluster"
  homepage "https://github.com/Eneco/landscaper"
  url "https://github.com/Eneco/landscaper.git",
      :tag => "1.0.7",
      :revision => "7909bb15127d2669e99548d312188ee74dbc0ecf"
  head "https://github.com/Eneco/landscaper.git"

  depends_on "go" => :build
  depends_on "glide" => :build
  depends_on "kubernetes-cli" => :run
  depends_on "kubernetes-helm" => :run

  def install
    ENV["GOPATH"] = buildpath
    ENV["GLIDE_HOME"] = HOMEBREW_CACHE/"glide_home/#{name}"
    ENV.prepend_create_path "PATH", buildpath/"bin"
    arch = MacOS.prefer_64_bit? ? "amd64" : "x86"
    ENV["TARGETS"] = "darwin/#{arch}"
    dir = buildpath/"src/github.com/eneco/landscaper"
    dir.install buildpath.children - [buildpath/".brew_home"]

    cd dir do
      # Bootstap build
      system "make", "bootstrap"

      # Make binary
      system "make", "build"
      bin.install "build/landscaper"
    end
  end

  test do
    version_output = shell_output("#{bin}/landscaper version 2>&1")
    assert_match stable.instance_variable_get(:@resource).instance_variable_get(:@specs)[:revision], version_output if build.stable?
  end
end
