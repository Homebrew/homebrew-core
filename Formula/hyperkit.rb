class Hyperkit < Formula
  desc "Toolkit for embedding hypervisor capabilities in your application"
  homepage "https://github.com/moby/hyperkit"
  url "https://github.com/moby/hyperkit/archive/v0.20180403.tar.gz"
  sha256 "e2739b034f20d9437696de48ace42600f55b7213292ec255032b2ef55f508297"

  depends_on "ocaml" => :build
  depends_on "opam" => :build
  depends_on :xcode => ["9.0", :build]

  depends_on "libev"

  def install
    system "opam", "init", "--no-setup"
    opam_dir = "#{buildpath}/.brew_home/.opam"
    ENV["CAML_LD_LIBRARY_PATH"] = "#{opam_dir}/system/lib/stublibs:/usr/local/lib/ocaml/stublibs"
    ENV["OPAMUTF8MSGS"] = "1"
    ENV["PERL5LIB"] = "#{opam_dir}/system/lib/perl5"
    ENV["OCAML_TOPLEVEL_PATH"] = "#{opam_dir}/system/lib/toplevel"
    ENV.prepend_path "PATH", "#{opam_dir}/system/bin"

    inreplace "#{opam_dir}/compilers/4.05.0/4.05.0/4.05.0.comp",
      '["./configure"', '["./configure" "-no-graph"' # Avoid X11

    ENV.deparallelize { system "opam", "switch", "4.05.0" }

    system "opam", "config", "exec", "--",
           "opam", "install", "-y", "uri", "qcow", "conduit.1.0.0", "lwt.3.1.0",
           "qcow-tool", "mirage-block-unix.2.9.0", "conf-libev", "logs", "fmt",
           "mirage-unix", "prometheus-app"

    args = []
    args << "GIT_VERSION=#{version}" if build.stable?
    system "opam", "config", "exec", "--", "make", *args

    bin.install "build/hyperkit"
  end

  test do
    pipe_output("#{bin}/hyperkit", "v")
  end
end
