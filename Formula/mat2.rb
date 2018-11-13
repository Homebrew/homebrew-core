class Mat2 < Formula
  desc "Metadata anonymization toolkit"
  homepage "https://0xacab.org/jvoisin/mat2"
  url "https://0xacab.org/jvoisin/mat2/uploads/e958dde527c7255e94ae2b347086ba9f/mat-0.6.0.tar.xz"
  sha256 "96c55c455a5d556bed41487476ae98866ebe8e7ef01a75325c9e274c7e1ce842"

  depends_on "exiftool"
  depends_on "ffmpeg"
  depends_on "poppler"
  depends_on "py3cairo"
  depends_on "pygobject3"
  depends_on "python"

  resource "mutagen" do
    url "https://files.pythonhosted.org/packages/source/m/mutagen/mutagen-1.41.1.tar.gz"
    sha256 "2ea9c900a05fa7f5f4c5bd9fc1475d7d576532e13b2f79b694452b997ff67200"
  end

  # fix list option return value
  patch :DATA

  def install
    inreplace "libmat2/exiftool.py", "/usr/bin/exiftool", "#{HOMEBREW_PREFIX}/bin/exiftool"
    inreplace "libmat2/video.py", "/usr/bin/ffmpeg", "#{HOMEBREW_PREFIX}/bin/ffmpeg"

    version = Language::Python.major_minor_version("python3")
    pygobject3 = Formula["pygobject3"]
    ENV["PYTHONPATH"] = lib/"python#{version}/site-packages"
    ENV.append_path "PYTHONPATH", pygobject3.opt_lib+"python#{version}/site-packages"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{version}/site-packages"

    resources.each do |r|
      r.stage do
        system "python3", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    system "python3", *Language::Python.setup_install_args(prefix)

    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/mat2", "-l"
  end
end

__END__
diff --git a/mat2 b/mat2
index ff8a253..151cbf6 100755
--- a/mat2
+++ b/mat2
@@ -133,7 +133,7 @@ def show_parsers() -> bool:
                 continue
             formats.add('  - %s (%s)' % (mtype, ', '.join(extensions)))
     print('\n'.join(sorted(formats)))
-    return True
+    return 0


 def __get_files_recursively(files: List[str]) -> Generator[str, None, None]:
