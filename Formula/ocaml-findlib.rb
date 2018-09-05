class OcamlFindlib < Formula
  desc "OCaml library manager"
  homepage "http://projects.camlcity.org/projects/findlib.html"
  url "http://download.camlcity.org/download/findlib-1.8.0.tar.gz"
  sha256 "2b7b7d6d65bb0f3f8a2c51c63c02b0bcf1fea4c23513f866140dc7dc24fe27ad"

  bottle do
    sha256 "6399780e078bca007730b218f4561ef4a513ba2296230aca2bcd9b6cfc75ea98" => :mojave
    sha256 "8c2e25008b18bde6fdbefacf85397ecd93a2b916d98c1e1954532509abbfd756" => :high_sierra
    sha256 "16682aa54745337c9aaae81fdd22000831c2b85b021250c6d4112fb94ab918a1" => :sierra
    sha256 "22b0228a6a116a7f22728b763c4d3e80b30b246a110fe726c5c572dde2d1073b" => :el_capitan
  end

  depends_on "ocaml"

  def install
    # See https://gitlab.camlcity.org/gerd/lib-findlib/merge_requests/8
    ENV.deparallelize

    system "./configure", "-bindir", bin,
                          "-mandir", man,
                          "-sitelib", lib/"ocaml",
                          "-config", etc/"findlib.conf",
                          "-no-topfind"
    system "make", "all"
    system "make", "opt"
    inreplace "findlib.conf", prefix, HOMEBREW_PREFIX
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/ocamlfind query findlib")
    assert_equal "#{HOMEBREW_PREFIX}/lib/ocaml/findlib", output.chomp
  end
end
