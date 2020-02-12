# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class Kpt < Formula
  desc "kpt is a toolkit to help you manage, manipulate, customize, and apply Kubernetes Resource configuration data files."
  homepage "https://googlecontainertools.github.io/kpt"
  url "https://github.com/GoogleContainerTools/kpt/archive/v0.4.0.zip"
  sha256 "9fa1d2a3d2ba38ee8c37ba5e01b3ecd77802d90748108ae7c96f4beb32af6cbf"

  # depends_on "cmake" => :build
  depends_on "go" => :build

  def install
    # ENV.deparallelize  # if your formula fails when building in parallel
    # Remove unrecognized options if warned by configure
    # system "./configure", "--disable-debug",
    #                       "--disable-dependency-tracking",
    #                       "--disable-silent-rules",
    #                       "--prefix=#{prefix}"
    # system "cmake", ".", *std_cmake_args
    ENV["GO111MODULE"] = on
    ENV["GOPATH"] = buildpath
    ENV.prepend_create_path "PATH", buildpath/"bin"
    dir = buildpath/"src/github.com/GoogleContainerTools/kpt"
    dir.install buildpath.children - [buildpath/".brew_home"]

    cd dir do
      #ENV.delete "AWS_ACCESS_KEY"
      #ENV.delete "AWS_SECRET_KEY"

      ENV["XC_OS"] = "darwin"
      ENV["XC_ARCH"] = "amd64"
      system "make", "build"

      bin.install "pkg/darwin_amd64/kpt"
      prefix.install_metafiles
    end

  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test kpt`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "false"
  end
end
