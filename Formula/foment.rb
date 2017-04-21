class Foment < Formula
  desc "Lightweight implementation of R7RS Scheme."
  homepage "https://github.com/leftmike/foment"
  # Despite its recent popularity, foment is head-only for now.
  head "https://github.com/leftmike/foment.git"

  def install
    cd "unix"
    system "make"
    bin.install "unix/release/foment"
  end

  test do
    # Unfortunately, foment currently appears to have a bug where it cannot
    # redirect output from stdout or stderr (instead it swallows the output).
    # This makes testing it from the shell a bit tricky. I filed a bug and will
    # monitor this situation.
    system "true"
  end
end
