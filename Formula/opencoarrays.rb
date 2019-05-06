class Opencoarrays < Formula
  desc "Open-source coarray Fortran ABI, API, and compiler wrapper"
  homepage "http://opencoarrays.org"
  url "https://github.com/sourceryinstitute/OpenCoarrays/releases/download/2.6.3/OpenCoarrays-2.6.3.tar.gz"
  sha256 "00884ad8e28385932ae9a1ad9b7fbe5cc69a3e0bee7fcba927894236a8adf422"
  head "https://github.com/sourceryinstitute/opencoarrays.git"

  bottle do
    cellar :any
    sha256 "2a691328b30915a6dde71d8eea90d8c02544f7ddf7a085709ca776d013edf5fb" => :mojave
    sha256 "a9e9526787015c784e17b34426e3740e1dbed0aaf316a3a5b60f453e070f4b56" => :high_sierra
    sha256 "7e922ec36d5ac37bf353d6eea0d53fb47c3e5ffb8f5f3b23a8c8d0ae6bfbcb4e" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "gcc"
  depends_on "open-mpi"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"tally.f90").write <<~EOS
      program main
        use iso_c_binding, only : c_int
        use iso_fortran_env, only : error_unit
        implicit none
        integer(c_int) :: tally
        tally = this_image() ! this image's contribution
        call co_sum(tally)
        verify: block
          integer(c_int) :: image
          if (tally/=sum([(image,image=1,num_images())])) then
             write(error_unit,'(a,i5)') "Incorrect tally on image ",this_image()
             error stop 2
          end if
        end block verify
        ! Wait for all images to pass the test
        sync all
        if (this_image()==1) write(*,*) "Test passed"
      end program
    EOS
    system "#{bin}/caf", "tally.f90", "-o", "tally"
    system "#{bin}/cafrun", "-np", "3", "--oversubscribe", "./tally"
  end
end
