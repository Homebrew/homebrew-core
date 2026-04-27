class JupyterR < Formula
  desc "R support for Jupyter"
  homepage "https://irkernel.github.io"
  url "https://github.com/IRkernel/IRkernel/archive/refs/tags/1.3.2.tar.gz", using: :nounzip
  sha256 "4ef2df1371e4b80dc1520da9186242998eb89eb0acfbc7d78de9aef4416bc358"
  license "MIT"
  revision 4

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8b52a2ecd5cae8b0e7f26d340f9070721b0b4b9e7b6160871f3723366c2fdeac"
    sha256 cellar: :any,                 arm64_sequoia: "7e058343e45031f0b0cc2400d979731b51837b30e9a35a5d26bf02e2af1695ea"
    sha256 cellar: :any,                 arm64_sonoma:  "cb7e41a453ba60a345463583a87809235e581037fb4ca44f58162a9bde730cbf"
    sha256 cellar: :any,                 sonoma:        "c2a981972fd3ad4a426099b7fa1aa75a3531e3c8a18eaf78f0bfe45baf19af99"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "abea55961a0952c101763e607ba86afa8c789a75d34769d09f1a274b2de20eb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "33bcd191c536ee0e3b8bb35b28b98823470e03d0147cfc90386dab6fe1451941"
  end

  depends_on "pkgconf" => :build
  depends_on "jupyterlab"
  depends_on "r"
  depends_on "zeromq"

  on_macos do
    depends_on "gettext"
  end

  resource "rlang" do
    url "https://cloud.r-project.org/src/contrib/rlang_1.2.0.tar.gz"
    mirror "https://cloud.r-project.org/src/contrib/Archive/rlang/rlang_1.2.0.tar.gz"
    sha256 "8f808ad4f6c1ba37d81b6a4a2cdb4a7d4d30d5bee4ba3e9924352d85a3874357"
  end

  resource "fastmap" do
    url "https://cloud.r-project.org/src/contrib/fastmap_1.2.0.tar.gz"
    mirror "https://cloud.r-project.org/src/contrib/Archive/fastmap/fastmap_1.2.0.tar.gz"
    sha256 "b1da04a2915d1d057f3c2525e295ef15016a64e6667eac83a14641bbd83b9246"
  end

  resource "ellipsis" do
    url "https://cloud.r-project.org/src/contrib/ellipsis_0.3.3.tar.gz"
    mirror "https://cloud.r-project.org/src/contrib/Archive/ellipsis/ellipsis_0.3.3.tar.gz"
    sha256 "da1782bce5c1baf1cf8c69877078db51fabf2693a393b55ff044fd2e32966873"
  end

  resource "cli" do
    url "https://cloud.r-project.org/src/contrib/cli_3.6.6.tar.gz"
    mirror "https://cloud.r-project.org/src/contrib/Archive/cli/cli_3.6.6.tar.gz"
    sha256 "b2b58d6dd82f5798b335e39c00591686a01fd3e94399ef898e146173e36f18f9"
  end

  resource "fansi" do
    url "https://cloud.r-project.org/src/contrib/fansi_1.0.7.tar.gz"
    mirror "https://cloud.r-project.org/src/contrib/Archive/fansi/fansi_1.0.7.tar.gz"
    sha256 "32a43f073aeb5c1d31c804014b95c2cb644bb4132119fcea313838b7ea4eb792"
  end

  resource "glue" do
    url "https://cloud.r-project.org/src/contrib/glue_1.8.1.tar.gz"
    mirror "https://cloud.r-project.org/src/contrib/Archive/glue/glue_1.8.1.tar.gz"
    sha256 "1c55905d3efc3d5c199ceb0bd12218e97f0d4c64df6038ff41ecef415478a122"
  end

  resource "lifecycle" do
    url "https://cloud.r-project.org/src/contrib/lifecycle_1.0.5.tar.gz"
    mirror "https://cloud.r-project.org/src/contrib/Archive/lifecycle/lifecycle_1.0.5.tar.gz"
    sha256 "61841e3e6edba056a88355a3f1d6698ab8d5d9cb3c05f2af0ec5a44ab516f8ee"
  end

  resource "utf8" do
    url "https://cloud.r-project.org/src/contrib/utf8_1.2.6.tar.gz"
    mirror "https://cloud.r-project.org/src/contrib/Archive/utf8/utf8_1.2.6.tar.gz"
    sha256 "4589f8b72291329e70b7f3a8c20f2feb4e7764eebad2e6976bc9a3eee7686ce9"
  end

  resource "vctrs" do
    url "https://cloud.r-project.org/src/contrib/vctrs_0.7.3.tar.gz"
    mirror "https://cloud.r-project.org/src/contrib/Archive/vctrs/vctrs_0.7.3.tar.gz"
    sha256 "b45078413e06ac624dddb7221a3a43908b405c8abec09822cb86638d30b0435b"
  end

  resource "base64enc" do
    url "https://cloud.r-project.org/src/contrib/base64enc_0.1-6.tar.gz"
    mirror "https://cloud.r-project.org/src/contrib/Archive/base64enc/base64enc_0.1-6.tar.gz"
    sha256 "3c7e9d22f7409fa2989008fa6e980c3dd8e2693eb20676acf2470ae7addb0816"
  end

  resource "digest" do
    url "https://cloud.r-project.org/src/contrib/digest_0.6.39.tar.gz"
    mirror "https://cloud.r-project.org/src/contrib/Archive/digest/digest_0.6.39.tar.gz"
    sha256 "8bf048b49b2d17077138fae758bda56bbd53278d9437f2fdeaedf979c90a13c9"
  end

  resource "htmltools" do
    url "https://cloud.r-project.org/src/contrib/htmltools_0.5.9.tar.gz"
    mirror "https://cloud.r-project.org/src/contrib/Archive/htmltools/htmltools_0.5.9.tar.gz"
    sha256 "19308618da485818f69dcfeeadd2ddc81d43a736a74519df7b3fd98e13128afd"
  end

  resource "pillar" do
    url "https://cloud.r-project.org/src/contrib/pillar_1.11.1.tar.gz"
    mirror "https://cloud.r-project.org/src/contrib/Archive/pillar/pillar_1.11.1.tar.gz"
    sha256 "056ce154238c9b5b8d5dcbcb52e1bc51d33870ce08c8a9ca9496478bd59f4653"
  end

  resource "jsonlite" do
    url "https://cloud.r-project.org/src/contrib/jsonlite_2.0.0.tar.gz"
    mirror "https://cloud.r-project.org/src/contrib/Archive/jsonlite/jsonlite_2.0.0.tar.gz"
    sha256 "75eb910c82b350ec33f094779da0f87bff154c232e4ae39c9896a9b89f3ac82d"
  end

  resource "repr" do
    url "https://cloud.r-project.org/src/contrib/repr_1.1.7.tar.gz"
    mirror "https://cloud.r-project.org/src/contrib/Archive/repr/repr_1.1.7.tar.gz"
    sha256 "73bd696b4d4211096e0d1e382d5ce6591527d2ff400cc7ae8230f0235eed021b"
  end

  resource "evaluate" do
    url "https://cloud.r-project.org/src/contrib/evaluate_1.0.5.tar.gz"
    mirror "https://cloud.r-project.org/src/contrib/Archive/evaluate/evaluate_1.0.5.tar.gz"
    sha256 "47aac79f889a828a5f8b4756cb972d7c2966bb984cbae17a4bd2389a73270794"
  end

  resource "IRdisplay" do
    url "https://cloud.r-project.org/src/contrib/IRdisplay_1.1.tar.gz"
    mirror "https://cloud.r-project.org/src/contrib/Archive/IRdisplay/IRdisplay_1.1.tar.gz"
    sha256 "83eb030ff91f546cb647899f8aa3f5dc9fe163a89a981696447ea49cc98e8d2b"
  end

  resource "pbdZMQ" do
    url "https://cloud.r-project.org/src/contrib/pbdZMQ_0.3-14.tar.gz"
    mirror "https://cloud.r-project.org/src/contrib/Archive/pbdZMQ/pbdZMQ_0.3-14.tar.gz"
    sha256 "60154f66db9378655d7c39c8c2e02e74ac6bd801a9aac1bc73003c7eeeb23223"
  end

  resource "crayon" do
    url "https://cloud.r-project.org/src/contrib/crayon_1.5.3.tar.gz"
    mirror "https://cloud.r-project.org/src/contrib/Archive/crayon/crayon_1.5.3.tar.gz"
    sha256 "3e74a0685541efb5ea763b92cfd5c859df71c46b0605967a0b5dbb7326e9da69"
  end

  resource "uuid" do
    url "https://cloud.r-project.org/src/contrib/uuid_1.2-2.tar.gz"
    mirror "https://cloud.r-project.org/src/contrib/Archive/uuid/uuid_1.2-2.tar.gz"
    sha256 "b1b73b87180d7b15095e6b33092ccf9dbd7ed3177791682711b8151ebbe9025f"
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
