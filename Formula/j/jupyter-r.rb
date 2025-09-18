class JupyterR < Formula
  desc "R support for Jupyter"
  homepage "https://irkernel.github.io"
  url "https://github.com/IRkernel/IRkernel/archive/refs/tags/1.3.2.tar.gz", using: :nounzip
  sha256 "4ef2df1371e4b80dc1520da9186242998eb89eb0acfbc7d78de9aef4416bc358"
  license "MIT"
  revision 3

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "1a568ad7acaa46dbc11d7166625d30c3f870d945db0459617717b71fd73f193b"
    sha256 cellar: :any,                 arm64_sequoia:  "9e60d5223a4c0794c025996a7c56b33ffbed5618aa930246c32cf13726b98cb8"
    sha256 cellar: :any,                 arm64_sonoma:   "f5e53d2e1c07fada5048527bf93c183650f8f4b5ec3bb088d2f27136d06ce3c3"
    sha256 cellar: :any,                 arm64_ventura:  "6b747fb9bf5f4b4cc3d115143b213ed41cefeb8afb2254f0cb643a621f20f87e"
    sha256 cellar: :any,                 arm64_monterey: "8aa1108c74e5910e683727b8b4a793fa5c0108361f8dbf8f199f5c105957c531"
    sha256 cellar: :any,                 sonoma:         "0316f97858c3952691008a53a36107235976bc213a24c894d89de8890c8822eb"
    sha256 cellar: :any,                 ventura:        "7d99a0c04195211aaad73759ee745a55823854e0d326e34627220103fbf4d545"
    sha256 cellar: :any,                 monterey:       "a10453cf63c2b498366e1a90dd42d47b828502a870e527684558d1bef37e07ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "20d47dc1d9832690199b9db766244d9a9a2fa8bf54b09441744b5dac333a8209"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c5b13b7b57330d27afc80e134f7d27c2b5207a9abc00a92f081d2fa21f834ede"
  end

  depends_on "pkgconf" => :build
  depends_on "jupyterlab"
  depends_on "r"
  depends_on "zeromq"

  on_macos do
    depends_on "gettext"
  end

  resource "rlang" do
    url "https://cloud.r-project.org/src/contrib/rlang_1.1.4.tar.gz"
    mirror "https://cloud.r-project.org/src/contrib/Archive/rlang/rlang_1.1.4.tar.gz"
    sha256 "f2d74527508bf3287102470beb27de0d234c3cbba399c28d3312f2c83c64a6e1"
  end

  resource "fastmap" do
    url "https://cloud.r-project.org/src/contrib/fastmap_1.2.0.tar.gz"
    mirror "https://cloud.r-project.org/src/contrib/Archive/fastmap/fastmap_1.2.0.tar.gz"
    sha256 "b1da04a2915d1d057f3c2525e295ef15016a64e6667eac83a14641bbd83b9246"
  end

  resource "ellipsis" do
    url "https://cloud.r-project.org/src/contrib/ellipsis_0.3.2.tar.gz"
    mirror "https://cloud.r-project.org/src/contrib/Archive/ellipsis/ellipsis_0.3.2.tar.gz"
    sha256 "a90266e5eb59c7f419774d5c6d6bd5e09701a26c9218c5933c9bce6765aa1558"
  end

  resource "cli" do
    url "https://cloud.r-project.org/src/contrib/cli_3.6.3.tar.gz"
    mirror "https://cloud.r-project.org/src/contrib/Archive/cli/cli_3.6.3.tar.gz"
    sha256 "4295085f11221c54b1dd2b1d39a675a85dfd9f900294297567e1d36f65ac4841"
  end

  resource "fansi" do
    url "https://cloud.r-project.org/src/contrib/fansi_1.0.6.tar.gz"
    mirror "https://cloud.r-project.org/src/contrib/Archive/fansi/fansi_1.0.6.tar.gz"
    sha256 "ea9dc690dfe50a7fad7c5eb863c157d70385512173574c56f4253b6dfe431863"
  end

  resource "glue" do
    url "https://cloud.r-project.org/src/contrib/glue_1.8.0.tar.gz"
    mirror "https://cloud.r-project.org/src/contrib/Archive/glue/glue_1.8.0.tar.gz"
    sha256 "c86f364ba899b8662f5da3e1a75f43ae081ab04e0d51171d052356e7ee4b72a0"
  end

  resource "lifecycle" do
    url "https://cloud.r-project.org/src/contrib/lifecycle_1.0.4.tar.gz"
    mirror "https://cloud.r-project.org/src/contrib/Archive/lifecycle/lifecycle_1.0.4.tar.gz"
    sha256 "ada4d3c7e84b0c93105e888647c5754219a8334f6e1f82d5afaf83d4855b91cc"
  end

  resource "utf8" do
    url "https://cloud.r-project.org/src/contrib/utf8_1.2.4.tar.gz"
    mirror "https://cloud.r-project.org/src/contrib/Archive/utf8/utf8_1.2.4.tar.gz"
    sha256 "418f824bbd9cd868d2d8a0d4345545c62151d321224cdffca8b1ffd98a167b7d"
  end

  resource "vctrs" do
    url "https://cloud.r-project.org/src/contrib/vctrs_0.6.5.tar.gz"
    mirror "https://cloud.r-project.org/src/contrib/Archive/vctrs/vctrs_0.6.5.tar.gz"
    sha256 "43167d2248fd699594044b5c8f1dbb7ed163f2d64761e08ba805b04e7ec8e402"
  end

  resource "base64enc" do
    url "https://cloud.r-project.org/src/contrib/base64enc_0.1-3.tar.gz"
    mirror "https://cloud.r-project.org/src/contrib/Archive/base64enc/base64enc_0.1-3.tar.gz"
    sha256 "6d856d8a364bcdc499a0bf38bfd283b7c743d08f0b288174fba7dbf0a04b688d"
  end

  resource "digest" do
    url "https://cloud.r-project.org/src/contrib/digest_0.6.37.tar.gz"
    mirror "https://cloud.r-project.org/src/contrib/Archive/digest/digest_0.6.37.tar.gz"
    sha256 "82c4d149994b8a4a9af930f5a8e47420829935abed41f3f9030e94b6a48f0321"
  end

  resource "htmltools" do
    url "https://cloud.r-project.org/src/contrib/htmltools_0.5.8.1.tar.gz"
    mirror "https://cloud.r-project.org/src/contrib/Archive/htmltools/htmltools_0.5.8.1.tar.gz"
    sha256 "f9f62293ec06c353c4584db6ccedb06a2da12e485208bd26b856f17dd013f176"
  end

  resource "pillar" do
    url "https://cloud.r-project.org/src/contrib/pillar_1.10.0.tar.gz"
    mirror "https://cloud.r-project.org/src/contrib/Archive/pillar/pillar_1.10.0.tar.gz"
    sha256 "97f6bb5d54388e9fbc2d6e5d3c883374105fadbc9c9aad38e7b4e1389970eadb"
  end

  resource "jsonlite" do
    url "https://cloud.r-project.org/src/contrib/jsonlite_1.8.9.tar.gz"
    mirror "https://cloud.r-project.org/src/contrib/Archive/jsonlite/jsonlite_1.8.9.tar.gz"
    sha256 "89f130e0e1163328c01decd54e7712b5ebf3d0a667da0052833722cb9a6e90b0"
  end

  resource "repr" do
    url "https://cloud.r-project.org/src/contrib/repr_1.1.7.tar.gz"
    mirror "https://cloud.r-project.org/src/contrib/Archive/repr/repr_1.1.7.tar.gz"
    sha256 "73bd696b4d4211096e0d1e382d5ce6591527d2ff400cc7ae8230f0235eed021b"
  end

  resource "evaluate" do
    url "https://cloud.r-project.org/src/contrib/evaluate_1.0.1.tar.gz"
    mirror "https://cloud.r-project.org/src/contrib/Archive/evaluate/evaluate_1.0.1.tar.gz"
    sha256 "436cc3e55b53e3c618b2f31324840875b5d66076c737af6fb31c650c783171e2"
  end

  resource "IRdisplay" do
    url "https://cloud.r-project.org/src/contrib/IRdisplay_1.1.tar.gz"
    mirror "https://cloud.r-project.org/src/contrib/Archive/IRdisplay/IRdisplay_1.1.tar.gz"
    sha256 "83eb030ff91f546cb647899f8aa3f5dc9fe163a89a981696447ea49cc98e8d2b"
  end

  resource "pbdZMQ" do
    url "https://cloud.r-project.org/src/contrib/pbdZMQ_0.3-13.tar.gz"
    mirror "https://cloud.r-project.org/src/contrib/Archive/pbdZMQ/pbdZMQ_0.3-13.tar.gz"
    sha256 "4139a88323642b734a83a8d73ea34550f8ef279389e794a5a3a5f3e8f579839a"
  end

  resource "crayon" do
    url "https://cloud.r-project.org/src/contrib/crayon_1.5.3.tar.gz"
    mirror "https://cloud.r-project.org/src/contrib/Archive/crayon/crayon_1.5.3.tar.gz"
    sha256 "3e74a0685541efb5ea763b92cfd5c859df71c46b0605967a0b5dbb7326e9da69"
  end

  resource "uuid" do
    url "https://cloud.r-project.org/src/contrib/uuid_1.2-1.tar.gz"
    mirror "https://cloud.r-project.org/src/contrib/Archive/uuid/uuid_1.2-1.tar.gz"
    sha256 "f90e49733d7d6ea7cf91abdc07b7d0e9a34a4b993e6914d754f0621281fc4b96"
  end

  def install
    rscript = Formula["r"].opt_bin/"Rscript"
    site_library = lib/"R/site-library"
    site_library.mkpath

    resources.each do |r|
      if r.patches.empty?
        # no need to decompress the resource at all
        system rscript, "-e",
          "install.packages(pkgs='#{r.cached_download}', lib='#{site_library}', type='source', repos=NULL)"
      else
        # staging automatically applies the patch
        r.stage do
          system rscript, "-e",
            "install.packages(pkgs='.', lib='#{site_library}', type='source', repos=NULL)"
        end
      end
    end

    system rscript, "-e",
      "install.packages(pkgs='#{buildpath}/IRkernel-#{version}.tar.gz', lib='#{site_library}', type='source', repos=NULL)"

    inreplace "#{site_library}/pbdZMQ/etc/Makeconf" do |s|
      s.gsub!(/PKG_CONFIG = .+/, "PKG_CONFIG = #{HOMEBREW_PREFIX}/bin/pkg-config")
      s.gsub! Formula["zeromq"].prefix.realpath, Formula["zeromq"].opt_prefix
    end

    ENV["R_LIBS"] = site_library
    system rscript, "-e", "library(IRkernel); IRkernel::installspec(user=FALSE, prefix='#{prefix}')"
    inreplace share/"jupyter/kernels/ir/kernel.json", Formula["r"].prefix.realpath, Formula["r"].opt_prefix
  end

  test do
    r_version = Formula["r"].version
    jupyter = Formula["jupyterlab"].opt_bin/"jupyter"

    ENV["JUPYTER_PATH"] = share/"jupyter"
    ENV["R_LIBS_SITE"] = lib/"R/site-library"
    assert_match " ir ", shell_output("#{jupyter} kernelspec list")

    require "expect"
    require "pty"
    PTY.spawn(jupyter, "console", "--kernel=ir") do |r, w, pid|
      timeout = 30
      r.expect("In [1]:", timeout) do |result|
        refute_nil result, "Expected In [1] prompt"
        assert_match "R version #{r_version}", result.first
      end
      w.write "print('Hello Homebrew')\r"
      r.expect("In [2]:", timeout) do |result|
        refute_nil result, "Expected In [2] prompt"
        assert_match '[1] "Hello Homebrew"', result.first
      end
      w.write "mean(c(1, 2, 3, 4))\r"
      r.expect("In [3]:", timeout) do |result|
        refute_nil result, "Expected In [3] prompt"
        assert_match "[1] 2.5", result.first
      end
      w.write "quit()\r"
    ensure
      r.close
      w.close
      Process.wait(pid)
    end
  end
end
