class Icl < Formula
  desc "Interactive Common Lisp: an enhanced REPL"
  homepage "https://github.com/atgreen/icl"
  url "https://github.com/atgreen/icl/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "4cf91be9208b38289939c88f1014f2d9dfa7b0a2ab1aecc0bf9a95633cdcafd7"
  license "MIT"

  depends_on "libfixposix" => :no_linkage # loaded via CFFI at runtime
  depends_on "ocicl"
  depends_on "sbcl"

  def install
    system "ocicl", "install"

    mkdir_p libexec
    system "sbcl", "--dynamic-space-size", "3072",
                   "--no-userinit",
                   "--eval", "(require 'asdf)",
                   "--eval", <<~LISP
                     (progn
                       (asdf:initialize-source-registry
                         (list :source-registry
                               :inherit-configuration
                               (list :directory (uiop:getcwd))
                               (list :tree (merge-pathnames "ocicl/" (uiop:getcwd)))
                               (list :tree (merge-pathnames "3rd-party/" (uiop:getcwd)))))
                       (asdf:load-system :icl)
                       (asdf:clear-source-registry)
                       (sb-ext:save-lisp-and-die "#{libexec}/icl.core"))
                   LISP

    pkgshare.install Dir["ocicl/sly-*/slynk"].first

    (pkgshare/"asdf").install "3rd-party/asdf/asdf.lisp"

    (libexec/"icl-bin").write <<~BASH
      #!/bin/bash
      exec #{Formula["sbcl"].opt_bin}/sbcl --noinform --core "#{libexec}/icl.core" --eval '(icl:main)'
    BASH
    chmod "+x", libexec/"icl-bin"

    env = {
      ICL_SLYNK_PATH: "#{pkgshare}/slynk/",
      ICL_ASDF_PATH:  "#{pkgshare}/asdf/asdf.lisp",
    }
    (bin/"icl").write_env_script libexec/"icl-bin", env
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/icl --version")

    (testpath/"factorial.lisp").write <<~LISP
      (defun factorial (n) (if (<= n 1) 1 (* n (factorial (- n 1)))))
      (format t "~a~%" (factorial 5))
      (quit)
    LISP
    assert_match "120", shell_output("#{bin}/icl < #{testpath}/factorial.lisp")
  end
end
