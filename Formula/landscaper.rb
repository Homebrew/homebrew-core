class Landscaper < Formula
  desc "Manage the application landscape in a Kubernetes cluster"
  homepage "https://github.com/Eneco/landscaper"
  url "https://github.com/Eneco/landscaper.git",
      tag:      "v1.0.24",
      revision: "1199b098bcabc729c885007d868f38b2cf8d2370"
  license "Apache-2.0"
  revision 1
  head "https://github.com/Eneco/landscaper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "835b3c32293b1725d2065652ecd2a0017ba2387351f586936230ff96030f79cb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d6d705dc7d36d5fd8f0f6abd093bd86398c799929069fa47f117deb25f5bbe0f"
    sha256 cellar: :any_skip_relocation, monterey:       "13cf71ffacb84e95c4346beec92e389893755f998f6f421b930b9adb5ccfdc5d"
    sha256 cellar: :any_skip_relocation, big_sur:        "bad7cf082826c5d92dd8c09a79b682e1582fcfc3f4e471dde4112393ec7095ce"
    sha256 cellar: :any_skip_relocation, catalina:       "74decffaf180e0e0dd9bfa2312877da01443a3418afe0f485c1b655c4af1da41"
    sha256 cellar: :any_skip_relocation, mojave:         "ff82cdb7be6329f9a4a5ce34bcbb04bc9356ab46fa3ecd30b830cf35df268529"
    sha256 cellar: :any_skip_relocation, high_sierra:    "68302c1748fe4eb063855df24420a8681a54b8ce484f2e030616bd4c4a812d52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a51ba397aeab58e4b2c68b916dcb3612aca5d7d383b6e4715db785e098270f4e"
  end

  # also depends on helm@2 (which failed to build)
  disable! date: "2022-07-31", because: :repo_archived

  depends_on "dep" => :build
  depends_on "go" => :build
  depends_on "helm@2"
  depends_on "kubernetes-cli"

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
    ENV.prepend_create_path "PATH", buildpath/"bin"
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    ENV["TARGETS"] = "#{OS.kernel_name.downcase}/#{arch}"
    dir = buildpath/"src/github.com/eneco/landscaper"
    dir.install buildpath.children - [buildpath/".brew_home"]

    cd dir do
      system "make", "bootstrap"
      system "make", "build"
      bin.install "build/landscaper"
      bin.env_script_all_files(libexec/"bin", PATH: "#{Formula["helm@2"].opt_bin}:$PATH")
      prefix.install_metafiles
    end
  end

  test do
    output = shell_output("#{bin}/landscaper apply --dry-run 2>&1", 1)
    assert_match "This is Landscaper v#{version}", output
    assert_match "dryRun=true", output
  end
end
