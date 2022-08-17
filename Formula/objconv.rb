class Objconv < Formula
  desc "Object file converter"
  homepage "https://www.agner.org/optimize/#objconv"
  url "https://www.agner.org/optimize/objconv.zip"
  version "2022-08-17"
  sha256 "024aa73b54022ae6ab19e4363b6b8e3654351a524f369e2090cd5cce5ae541f0"
  license "GPL-3.0-or-later"

  livecheck do
    url :homepage
    regex(/objconv.*last\s+modified:\s+(\d{4}-(?:[A-Z][a-z]{2}|\d{2})+-\d{2})/i)
    strategy :page_match do |page, regex|
      date = page.scan(regex).flatten.first
      next if date.blank?

      Date.parse(date).strftime("%Y-%m-%d")
    end
  end

  uses_from_macos "unzip" => :build

  def install
    system "unzip", "source"
    system "./build.sh"

    bin.install "objconv"
    doc.install "objconv-instructions.pdf"
  end

  test do
    (testpath/"foo.c").write "int foo() { return 0; }\n"

    # objconv can only translate x86_64 object files
    if OS.mac? && Hardware::CPU.arm?
      ENV.append_to_cflags "-arch x86_64"
      ENV.append "LDFLAGS", "-Wl,-arch,x86_64"
    end

    system "make", "foo.o"
    assert_match "foo", shell_output("nm foo.o")

    # Rename `foo` to `main`. At least one of `make` or `./bar` will fail if this did not succeed.
    sym_prefix = OS.mac? ? "_" : ""
    system bin/"objconv", "-nr:#{sym_prefix}foo:#{sym_prefix}main", "foo.o", "bar.o"
    system "make", "bar"
    refute_match "foo", shell_output("nm bar")

    # We're about to execute an x86_64 binary, but we might not have Rosetta installed.
    return if OS.mac? && Hardware::CPU.arm?

    system "./bar"
  end
end
